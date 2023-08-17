defmodule LessonWeb.Admin.Account.JoiningRequestLive do
  use LessonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, requests} = Lesson.read(Lesson.JoiningRequest)

    form = to_form(%{})

    socket =
      assign(
        socket,
        requests: requests,
        form: form
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", unsigned_params, socket) do
    delete_target_ids =
      unsigned_params
      |> Enum.filter(fn {_, value} -> value == "true" end)
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()

    delete_target_records =
      Enum.filter(socket.assigns.requests, fn request -> request.id in delete_target_ids end)

    Enum.each(delete_target_records, fn request -> Lesson.destroy!(request) end)

    {:ok, requests} = Lesson.read(Lesson.JoiningRequest)
    {:noreply, assign(socket, requests: requests)}
  end
end
