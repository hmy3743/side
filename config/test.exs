import Config

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "side_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lesson_web, LessonWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "V181833Jbp2ZSeMhOlYdU+Re13WqMrrCqmu4cevXnOlzFecOIjy2DvhZaZt1jKey",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
