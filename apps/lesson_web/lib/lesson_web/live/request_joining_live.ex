defmodule LessonWeb.RequestJoiningLive do
  use LessonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    form =
      Lesson.JoiningRequest
      |> AshPhoenix.Form.for_create(:create)
      |> to_form()

    {:ok, assign(socket, form: form)}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _request} ->
        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end
end
