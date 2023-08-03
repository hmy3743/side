defmodule Lesson.JoiningRequest do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

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

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  actions do
    defaults [:create, :read, :update]
  end

  postgres do
    table "joining_request"
    repo Core.Repo
  end
end
