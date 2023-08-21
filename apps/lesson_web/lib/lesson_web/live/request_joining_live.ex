defmodule LessonWeb.RequestJoiningLive do
  alias Lesson.JoiningRequest
  use LessonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    form =
      Lesson.JoiningRequest
      |> AshPhoenix.Form.for_create(:create, api: Lesson)
      |> to_form()

    {:ok, assign(socket, form: form, request: nil)}
  end

  @impl true
  def handle_params(unsigned_params, _uri, socket) do
    request =
      with {:ok, request} <- Lesson.get(JoiningRequest, unsigned_params["request_id"]) do
        request
      end

    socket =
      case request do
        %Lesson.JoiningRequest{} ->
          form =
            request
            |> AshPhoenix.Form.for_update(:update, api: Lesson)
            |> to_form()

          assign(socket, request: request, form: form)

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
  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, request} ->
        socket =
          socket
          |> patch_to_result(request)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp patch_to_result(socket, request) do
    case socket.assigns do
      %{request: %Lesson.JoiningRequest{}} ->
        push_navigate(socket, to: ~p"/result?#{[message_id: "joining", destination: "/"]}")

      _ ->
        push_patch(socket, to: ~p"/request_joining?#{[request_id: request.id]}")
    end
  end
end
