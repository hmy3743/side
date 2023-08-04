defmodule LessonWeb.RequestJoiningLive do
  use LessonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    form =
      Lesson.JoiningRequest
      |> AshPhoenix.Form.for_create(:create, api: Lesson)
      |> to_form()

    {:ok, assign(socket, form: form)}
  end

  @impl true
  def handle_params(unsigned_params, _uri, socket) do
    socket =
      case unsigned_params["request_id"] do
        request_id when is_binary(request_id) ->
          assign(socket, request_id: request_id)

        _ ->
          socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("create", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, request} ->
        {:noreply, push_patch(socket, to: ~p"/request_joining?#{[request_id: request.id]}")}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end
end
