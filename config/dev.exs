import Config

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "side_dev",
  port: 5432,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :core, :token_signing_secret, "secret"

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :lesson_web, LessonWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "QeTRJv4FKIjKskA5rk6UBIOBDAne0LtnGAZJc+QpPIZwbwNyW7u/8S5i5I7/NmPU",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:lesson_web, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:lesson_web, ~w(--watch)]}
  ]

config :shadow_chat, ShadowChatWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4001],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "G9HOONaU8RauIuFJ0x/bNThaJPgmEIECRFJQtnbyBb3yPzQibAZJrIGq6zqZJpOZ",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:shadow_chat, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:shadow_chat, ~w(--watch)]}
  ]

config :content_diary, ContentDiaryWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4002],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "t5jaW0IsgHjFCblrzaiL8ccbxyr2wQeJW1NznD/MKduw5faEppmasPGEvbgAaXQ7",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:content_diary, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:content_diary, ~w(--watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :lesson_web, LessonWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/lesson_web_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Watch static and templates for browser reloading.
config :shadow_chat, ShadowChatWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/shadow_chat_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :content_diary, ContentDiaryWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/content_diary_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :lesson_web, dev_routes: true
config :shadow_chat, dev_routes: true
config :content_diary, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :openai,
  api_key: System.get_env("OPENAI_API_KEY"),
  organization_key: System.get_env("OPENAI_ORGANIZATION_KEY")
