defmodule RunBook do
  alias Ash.Changeset
  alias Core.SNS

  def publish_feed_item!(text \\ "blah blah") do
    SNS.FeedItem
    |> Changeset.for_create(:publish, %{text: text})
    |> SNS.create!()
  end

  def destroy_feed_item!(feed_item) do
    feed_item
    |> Changeset.for_destroy(:destroy)
    |> SNS.destroy!()
  end

  def publish_sub_feed_item!(feed_item_id, text \\ "blah blah") do
    SNS.SubFeedItem
    |> Changeset.for_create(:publish, %{text: text, feed_item_id: feed_item_id})
    |> SNS.create!()
  end
end

require Ash.Query
import RunBook
alias Ash.Query
alias Core.SNS
alias Core.SNS.{FeedItem, SubFeedItem}

feed_item = publish_feed_item!()
sub_feed_items = [
  publish_sub_feed_item!(feed_item.id),
  publish_sub_feed_item!(feed_item.id),
  publish_sub_feed_item!(feed_item.id)
]

result = FeedItem.read!(query: Query.filter(FeedItem, text == "blah blah"))
