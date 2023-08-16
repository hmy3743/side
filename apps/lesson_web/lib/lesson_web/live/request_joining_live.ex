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
          |> submit_flash()
          |> patch_patch(request)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp submit_flash(socket) do
    case socket.assigns do
      %{request: %Lesson.JoiningRequest{}} ->
        put_flash(socket, :info, gettext("추가정보가 입력되었습니다.  감사합니다."))

      _ ->
        put_flash(socket, :info, gettext("요청이 성공적으로 접수되었습니다.  2,3일 이내에 연락드리겠습니다."))
    end
  end

  defp patch_patch(socket, request) do
    case socket.assigns do
      %{request: %Lesson.JoiningRequest{}} -> push_navigate(socket, to: ~p"/")
      _ -> push_patch(socket, to: ~p"/request_joining?#{[request_id: request.id]}")
    end
  end
end
