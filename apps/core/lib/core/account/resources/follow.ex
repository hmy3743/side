defmodule Core.Account.Follow do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:create, :read, :destroy]

    action :follow, __MODULE__ do
      argument :follower_id, :uuid, allow_nil?: false
      argument :followee_id, :uuid, allow_nil?: false

      run(fn %{arguments: %{follower_id: follower_id, followee_id: followee_id}}, _context ->
        follow = __MODULE__.create!(follower_id, followee_id)
        %{followee: %{published_feed_items: feed_items}} = Core.Account.load!(follow, [followee: :published_feed_items])
        Enum.each(feed_items, fn feed_item ->
          Core.SNS.Feed.create!(follower_id, feed_item.id)
        end)
        {:ok, follow}
      end)
    end
  end

  attributes do
    attribute :follower_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :followee_id, :uuid, primary_key?: true, allow_nil?: false

    create_timestamp :inserted_at
  end

  relationships do
    belongs_to :follower, Core.Account.User, allow_nil?: false
    belongs_to :followee, Core.Account.User, allow_nil?: false
  end

  code_interface do
    define_for Core.Account

    define :create, args: [:followee_id, :follower_id]
    define :follow, args: [:followee_id, :follower_id]
  end
end
