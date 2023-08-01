defmodule LessonWeb.Admin.Account.AccountCreatingLive do
  use LessonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
