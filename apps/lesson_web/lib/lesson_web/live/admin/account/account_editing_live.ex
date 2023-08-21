defmodule LessonWeb.Admin.Account.AccountEditingLive do
  use LessonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_new(:users, fn -> Core.Account.read!(Core.Account.User) end)
      |> assign(user: nil, form: nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    user = get_user_from_params(params)

    socket =
      socket
      |> assign(:user, user)
      |> assign_form(user)

    {:noreply, socket}
  end

  @impl true
  def handle_event("update", _unsigned_params, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/account/editing")}
  end

  @impl true
  def handle_event("delete", %{"id" => _user_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/admin/account/editing")}
  end

  defp assign_form(socket, %Core.Account.User{} = user) do
    form =
      user
      |> AshPhoenix.Form.for_update(:update, api: Core.Account)
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_form(socket, _) do
    assign(socket, form: nil)
  end

  defp get_user_from_params(params) do
    with %{"id" => user_id} <- params,
         {:ok, user} <- Core.Account.get(Core.Account.User, user_id) do
      user
    else
      _ -> nil
    end
  end
end
