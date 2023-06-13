defmodule Core.SNS.Registry do
  use Ash.Registry

  entries do
    entry Core.SNS.FeedItem
    entry Core.SNS.SubFeedItem
  end
end
