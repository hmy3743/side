defmodule Core.Repo.Migrations.AddJoiningRequest do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:joining_request, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
      add :first_name, :text, null: false
      add :last_name, :text, null: false
      add :contact, :text, null: false
      add :gender, :text
      add :age, :bigint
      add :level, :text
      add :purpose, :text
      add :comment, :text
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")
    end
  end

  def down do
    drop table(:joining_request)
  end
end