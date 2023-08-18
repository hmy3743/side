defmodule LessonWeb.Admin.Account.AccountCreatingLive do
  use LessonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    form =
      Core.Account.User
      |> AshPhoenix.Form.for_create(:create, api: Core.Account)
      |> to_form()

    {:ok, assign(socket, form: form)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    request = request_from_param(params)
    {:noreply, assign(socket, request: request)}
  end

  @impl true
  def handle_event("validate", %{"form" => param}, socket) do
    socket = update(socket, :form, &AshPhoenix.Form.validate(&1, param))
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit", %{"form" => params}, socket) do
    AshPhoenix.Form.submit!(socket.assigns.form, params: params) |> IO.inspect()
    {:noreply, socket}
  end

  defp request_from_param(params) do
    case Lesson.get(Lesson.JoiningRequest, params["request_id"]) do
      {:ok, request} -> request
      _ -> nil
    end
  end

  defp request_value(%Lesson.JoiningRequest{} = request, key) do
    [value: Map.fetch!(request, key)]
  end

  defp request_value(_, _), do: []
end
