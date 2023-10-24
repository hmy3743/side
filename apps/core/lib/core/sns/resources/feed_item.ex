defmodule Core.SNS.FeedItem do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      accept [:text]

      argument :author_id, :uuid, allow_nil?: false
      argument :expose_scope, :atom, allow_nil?: false, default: :public

      change manage_relationship(:author_id, :author, type: :append_and_remove)
    end

    action :publish, :module do
      argument :text, :string, allow_nil?: false
      argument :author_id, :uuid, allow_nil?: false
      argument :expose_scope, :atom, allow_nil?: false, default: :public

      run(fn %{arguments: %{text: text, author_id: author_id, expose_scope: expose_scope}},
             _context ->
        feed_item = __MODULE__.create!(text, author_id, expose_scope)

        %{author: %{followers: followers} = author} =
          Core.SNS.load!(feed_item, author: :followers)

        Enum.each(followers, fn follower ->
          Core.SNS.Feed.create!(follower.id, feed_item.id)
        end)

        {:ok, feed_item}
      end)
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
    define :create, args: [:text, :author_id, {:optional, :expose_scope}]
    define :publish, args: [:text, :author_id, {:optional, :expose_scope}]
    define :set_private, args: []
    define :set_friends, args: []
    define :set_public, args: []
  end
end
