defmodule Core.SNS.SubFeedItem do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:create, :read, :update, :destroy]

    create :publish do
      accept [:text]

      argument :feed_item_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:feed_item_id, :feed_item, type: :append_and_remove)
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :text, :string do
      allow_nil? false
    end
  end

  relationships do
    belongs_to :feed_item, Core.SNS.FeedItem
  end
end
