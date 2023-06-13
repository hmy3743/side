import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :core, Core.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :core,
         :token_signing_secret,
         System.get_env("TOKEN_SIGNING_SECRET") ||
           raise("environment variable TOKEN_SIGNING_SECRET is missing.")
end
