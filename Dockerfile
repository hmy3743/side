# Use an official Elixir image as the base image
ARG ELIXIR_VERSION=1.15.4
ARG OTP_VERSION=26.0.2
ARG DEBIAN_VERSION=bullseye-20230612-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

ENV MIX_ENV="prod"
# Set the working directory inside the container
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force

# Install rebar (required by some Elixir packages)
RUN mix local.rebar --force

# Install Node.js and NPM (required for Phoenix assets)
RUN apt-get update -y && apt-get install -y nodejs build-essential

# Install Phoenix (make sure to replace "x.x.x" with the appropriate version)
RUN mix archive.install hex phx_new 1.7.2 --force

COPY mix.exs mix.lock ./
COPY apps/core/mix.exs ./apps/core/mix.exs
COPY apps/lesson_web/mix.exs ./apps/lesson_web/mix.exs
RUN mix deps.get
RUN mix deps.compile
RUN mix compile
RUN mix esbuild.install && rm -rf _build/dev
RUN mix tailwind.install && rm -rf _build/dev

# Copy the entire umbrella project to the container
COPY . .

# Install dependencies for the umbrella project
RUN mix deps.get

# Set the environment variables for the Phoenix app
ENV MIX_ENV=prod
ENV PORT=4000

# Compile the umbrella project and assets
RUN mix compile
RUN mix assets.deploy

ARG RELEASE
ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

RUN mix release ${RELEASE}

FROM ${RUNNER_IMAGE} as runner
WORKDIR /app
ARG RELEASE
ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"
ENV PHX_SERVER="true"

COPY --from=builder /app/_build/${MIX_ENV}/rel/${RELEASE} .

# Expose the Phoenix port (change this to the actual port you use in the Phoenix app)
EXPOSE 4000

# Start the Phoenix app (adjust the command based on your actual entrypoint)
CMD ["./bin/lesson", "start"]
