defmodule Core.Repo.Migrations.CreatePrefixPasskey do
  use Ecto.Migration

  def up do
    Core.Repo.query!("CREATE SCHEMA IF NOT EXISTS passkey")
  end

  def down do
    Core.Repo.query!("DROP SCHEMA IF EXISTS passkey CASCADE")
  end
end
