defmodule Core.SNS.FeedItem do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:create, :read, :update, :destroy]

    create :publish do
      accept [:text]
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
      constraints [one_of: [:public, :friends, :private]]

      default :public

      allow_nil? false
    end
  end

  relationships do
    has_many :sub_feed_items, Core.SNS.SubFeedItem
  end

  code_interface do
    define_for Core.SNS

    define :publish, args: [:text]
    define :read, args: []
  end
end
