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
