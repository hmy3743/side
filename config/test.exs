import Config

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "side_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool_size: 10
