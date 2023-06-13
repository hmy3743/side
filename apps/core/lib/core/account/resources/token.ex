defmodule Core.Account.Token do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshAuthentication.TokenResource]

  token do
    api Core.Account
  end
end
