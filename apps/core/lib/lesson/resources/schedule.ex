defmodule Lesson.Schedule do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :since, :utc_datetime, allow_nil?: false
    attribute :until, :utc_datetime, allow_nil?: false
    attribute :type, :atom, constraints: [one_of: [:idle, :lesson]]

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :owner, Core.Account.User, allow_nil?: false, api: Core.Account
    belongs_to :pair, Lesson.Schedule
  end

  postgres do
    table "schedule"
    repo Core.Repo
  end
end
