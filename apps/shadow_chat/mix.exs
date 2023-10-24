defmodule ShadowChat.MixProject do
  use Mix.Project

  def project do
    [
      app: :shadow_chat,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ShadowChat.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:core, in_umbrella: true},
      {:phoenix, ">= 0.0.0"},
      {:phoenix_html, ">= 0.0.0"},
      {:phoenix_live_reload, ">= 0.0.0", only: :dev},
      {:phoenix_live_view, ">= 0.0.0"},
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_live_dashboard, ">= 0.0.0"},
      {:esbuild, ">= 0.0.0", runtime: Mix.env() == :dev},
      {:tailwind, ">= 0.0.0", runtime: Mix.env() == :dev},
      {:swoosh, ">= 0.0.0"},
      {:finch, ">= 0.0.0"},
      {:telemetry_metrics, ">= 0.0.0"},
      {:telemetry_poller, ">= 0.0.0"},
      {:gettext, ">= 0.0.0"},
      {:jason, ">= 0.0.0"},
      {:plug_cowboy, ">= 0.0.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind shadow_chat", "esbuild shadow_chat"],
      "assets.deploy": [
        "tailwind shadow_chat --minify",
        "esbuild shadow_chat --minify",
        "phx.digest"
      ]
    ]
  end
end
