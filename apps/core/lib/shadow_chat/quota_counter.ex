defmodule ShadowChat.QuotaCounter do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def count do
    Agent.get_and_update(__MODULE__, fn count -> {count, abs(count - 1)} end)
  end

  def get do
    Agent.get(__MODULE__, fn count -> count end)
  end
end
