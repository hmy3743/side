defmodule Core.Repo.Migrations.AlterUserAddRole do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:user) do
      modify :purpose, :text, null: true
      modify :level, :text, null: true
      add :role, :text
    end
  end

  def down do
    alter table(:user) do
      remove :role
      modify :level, :text, null: false
      modify :purpose, :text, null: false
    end
  end
end