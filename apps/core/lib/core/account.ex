defmodule Core.Account do
  use Ash.Api

  resources do
    registry Core.Account.Registry
  end
end
