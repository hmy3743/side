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
    defaults = [text: "blah blah", expose_scope: :public]
    %{text: text, author_id: author_id, expose_scope: expose_scope} =
      Keyword.merge(defaults, opts)
      |> Enum.into(%{})

    SNS.FeedItem.publish!(text, author_id, expose_scope)
  end

  def destroy_feed_item!(feed_item) do
    feed_item
    |> Changeset.for_destroy(:destroy)
    |> SNS.destroy!()
  end

  def publish_sub_feed_item!(opts \\ []) do
    defaults = [text: "blah blah"]
    %{text: text, feed_item_id: feed_item_id, author_id: author_id} =
      Keyword.merge(defaults, opts)
      |> Enum.into(%{})

    SNS.SubFeedItem.publish!(text, feed_item_id, author_id)
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
follow(follower, followee)
feed_item = publish_feed_item!(author_id: followee.id)
# sub_feed_items = [
#   publish_sub_feed_item!(feed_item_id: feed_item.id, author_id: follower.id),
#   publish_sub_feed_item!(feed_item_id: feed_item.id, author_id: follower.id),
#   publish_sub_feed_item!(feed_item_id: feed_item.id, author_id: follower.id)
# ]
# [follower, followee] = Account.load!([follower, followee], [:followers, :followees, :feeds])

%{author: %{followers: fw}} = SNS.load!(feed_item, [author: :followers])
%{author: %{followers: fw_lazy}} = SNS.load!(feed_item, [author: :followers], lazy?: true)
IO.inspect({fw, fw_lazy})
IO.inspect(fw == fw_lazy)
