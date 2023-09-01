defmodule Core.Repo do
  use AshPostgres.Repo, otp_app: :core

  @impl true
  def installed_extensions() do
    ["uuid-ossp", "citext"]
  end
end
