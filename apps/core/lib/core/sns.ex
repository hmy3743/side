defmodule Core.SNS do
  use Ash.Api

  resources do
    registry Core.SNS.Registry
  end
end
