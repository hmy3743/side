defmodule Side.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      releases: [
        lesson: [
          applications: [lesson_web: :permanent]
        ],
        shadow_chat: [
          applications: [shadow_chat: :permanent]
        ],
        content_diary: [
          applications: [content_diary: :permanent]
        ]
      ],
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:phoenix_live_view, ">= 0.0.0"},
      {:esbuild, ">= 0.0.0"},
      {:tailwind, ">= 0.0.0"}
    ]
  end
end
