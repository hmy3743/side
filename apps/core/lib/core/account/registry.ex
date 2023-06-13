defmodule Core.Account.Registry do
  use Ash.Registry, extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry Core.Account.User
    entry Core.Account.Token
  end
end
