defmodule Core.SNS.SubFeedItem do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:create, :read, :update, :destroy]

    create :publish do
      accept [:text]

      argument :author_id, :uuid, allow_nil?: false
      argument :feed_item_id, :uuid, allow_nil?: false

      change manage_relationship(:author_id, :author, type: :append_and_remove)
      change manage_relationship(:feed_item_id, :feed_item, type: :append_and_remove)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :text, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :author, Core.Account.User, allow_nil?: false, api: Core.Account
    belongs_to :feed_item, Core.SNS.FeedItem, allow_nil?: false
  end

  code_interface do
    define_for Core.SNS

    define :read, args: []
    define :publish, args: [:text, :feed_item_id, :author_id]
  end
end
