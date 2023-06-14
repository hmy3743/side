defmodule Core.SNS.FeedItem do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:create, :read, :update, :destroy]

    create :publish do
      accept [:text]

      argument :author_id, :uuid, allow_nil?: false
      argument :expose_scope, :atom, allow_nil?: false, default: :public

      change manage_relationship(:author_id, :author, type: :append_and_remove)
    end

    update :set_private do
      accept []

      change set_attribute(:expose_scope, :private)
    end

    update :set_friends do
      accept []

      change set_attribute(:expose_scope, :friends)
    end

    update :set_public do
      accept []

      change set_attribute(:expose_scope, :public)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :text, :string do
      allow_nil? false
    end

    attribute :expose_scope, :atom do
      constraints one_of: [:public, :friends, :private]
      default :public
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :author, Core.Account.User, allow_nil?: false, api: Core.Account
    has_many :sub_feed_items, Core.SNS.SubFeedItem
  end

  code_interface do
    define_for Core.SNS

    define :read, args: []
    define :publish, args: [:text, :author_id, {:optional, :expose_scope}]
    define :set_private, args: []
    define :set_friends, args: []
    define :set_public, args: []
  end
end
