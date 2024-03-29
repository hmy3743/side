# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :ash, :use_all_identities_in_manage_relationship?, false
config :core, :ash_apis, [Core.SNS, Core.Account, Lesson]
config :core, ecto_repos: [Core.Repo]

# Configures the endpoint
config :lesson_web, LessonWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: LessonWeb.ErrorHTML, json: LessonWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: LessonWeb.PubSub,
  live_view: [signing_salt: "GX/IE77G"]

# Configures the endpoint
config :shadow_chat, ShadowChatWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ShadowChatWeb.ErrorHTML, json: ShadowChatWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ShadowChat.PubSub,
  live_view: [signing_salt: "GX/IE77G"]

config :content_diary, ContentDiaryWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ContentDiaryWeb.ErrorHTML, json: ContentDiaryWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ContentDiary.PubSub,
  live_view: [signing_salt: "GX/IE77G"]

# Configures the endpoint
config :cona_web, ConaWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: ConaWeb.ErrorHTML, json: ConaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ConaWeb.PubSub,
  live_view: [signing_salt: "8ccC4nD7"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  lesson_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/lesson_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  shadow_chat: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/shadow_chat/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  content_diary: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/content_diary/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  cona: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/cona_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  lesson_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/lesson_web/assets", __DIR__)
  ],
  shadow_chat: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/shadow_chat/assets", __DIR__)
  ],
  content_diary: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/content_diary/assets", __DIR__)
  ],
  cona: [
    args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
    cd: Path.expand("../apps/cona_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :openai, http_options: [recv_timeout: 30_000]

import_config "#{config_env()}.exs"
