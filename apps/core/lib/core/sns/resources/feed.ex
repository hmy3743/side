defmodule Core.SNS.Feed do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:create, :read, :destroy]
  end

  attributes do
    attribute :owner_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :feed_item_id, :uuid, primary_key?: true, allow_nil?: false
  end

  relationships do
    belongs_to :owner, Core.Account.User, allow_nil?: false, api: Core.Account
    belongs_to :feed_item, Core.SNS.FeedItem, allow_nil?: false
  end

  code_interface do
    define_for Core.SNS

    define :create, args: [:owner_id, :feed_item_id]
  end
end
