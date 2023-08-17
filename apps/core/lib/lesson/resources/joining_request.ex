defmodule Lesson.JoiningRequest do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  resource do
    base_filter is_nil: :deleted_at
  end

  attributes do
    uuid_primary_key :id

    attribute :first_name, :string,
      constraints: [min_length: 1, max_length: 20],
      allow_nil?: false

    attribute :last_name, :string, constraints: [min_length: 1, max_length: 20], allow_nil?: false
    attribute :contact, :string, allow_nil?: false

    attribute :gender, :atom, constraints: [one_of: [:male, :female, :etc]]
    attribute :age, :integer, constraints: [min: 1, max: 100]
    attribute :level, :atom, constraints: [one_of: [:beginner, :intermediate, :advanced]]
    attribute :purpose, :atom, constraints: [one_of: [:business, :travel, :hobby, :etc]]
    attribute :comment, :string, constraints: [max_length: 1000]

    attribute :deleted_at, :utc_datetime
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  identities do
    identity :contact, [:contact], pre_check_with: Lesson
  end

  actions do
    defaults [:create, :read, :update]

    destroy :soft_delete do
      change set_attribute(:deleted_at, &DateTime.utc_now/0)
      soft? true
      primary? true
    end
  end

  postgres do
    table "joining_request"
    repo Core.Repo
    base_filter_sql "deleted_at IS NULL"
  end
end
