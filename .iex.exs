defmodule RunBook do
  alias Ash.Changeset
  alias Core.SNS
  alias Core.Account

  def clean() do
    Account.User
    |> Account.read!()
    |> Enum.each(&Account.destroy!/1)
  end

  def publish_feed_item!(opts \\ []) do
    defaults = [text: "blah blah"]
    attr =
      Keyword.merge(defaults, opts)
      |> Enum.into(%{})

    SNS.FeedItem
    |> Changeset.for_create(:publish, attr)
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

  def register_user!(opts \\ []) do
    defaults = [name: "Noel", email: "noel@aidkr.com", password: "password"]
    attr =
      Keyword.merge(defaults, opts)
      |> Enum.into(%{})

    Account.User
    |> Changeset.for_create(:register, attr)
    |> Account.create!()
  end

  def follow(follower = %Account.User{}, followee = %Account.User{}) do
    Account.Follow.follow!(follower.id, followee.id)
  end
end

require Ash.Query
import RunBook
alias Ash.Query
alias Core.{Account, SNS}
alias Core.SNS.{FeedItem, SubFeedItem}
alias Core.Account.User

clean()

follower = register_user!()
followee = register_user!(email: "followee@aidkr.com")
follow(followee, follower)
feed_item = publish_feed_item!(author_id: follower.id)
sub_feed_items = [
  publish_sub_feed_item!(feed_item.id),
  publish_sub_feed_item!(feed_item.id),
  publish_sub_feed_item!(feed_item.id)
]
[follower, followee] = Account.load!([follower, followee], [:followers, :followees])
