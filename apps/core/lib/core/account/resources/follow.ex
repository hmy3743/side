defmodule Core.Account.Follow do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:create, :read, :update, :destroy]

    create :follow do
      accept []

      argument :follower_id, :uuid, allow_nil?: false
      argument :followee_id, :uuid, allow_nil?: false

      change manage_relationship(:follower_id, :follower, type: :append_and_remove)
      change manage_relationship(:followee_id, :followee, type: :append_and_remove)
    end
  end

  attributes do
    attribute :follower_id, :uuid do
      primary_key? true
      allow_nil? false
    end

    attribute :followee_id, :uuid do
      primary_key? true
      allow_nil? false
    end
  end

  relationships do
    belongs_to :follower, Core.Account.User, allow_nil?: false
    belongs_to :followee, Core.Account.User, allow_nil?: false
  end

  code_interface do
    define_for Core.Account

    define :follow, args: [:followee_id, :follower_id]
  end
end
