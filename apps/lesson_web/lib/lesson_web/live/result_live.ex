defmodule LessonWeb.ResultLive do
  use LessonWeb, :live_view

  @impl true
  def handle_params(params, _uri, socket) do
    message = get_message(params["message_id"])
    destination = get_destination(params["destination"])

    Process.send_after(self(), :deliver, 5_000)

    {:noreply, assign(socket, message: message, destination: destination)}
  end

  @impl true
  def handle_info(:deliver, socket) do
    {:noreply, push_navigate(socket, to: socket.assigns.destination.value)}
  end

  defp get_message(message_id) do
    Map.get_lazy(
      %{
        "default" => gettext("감사합니다."),
        "joining" => gettext("가입 요청 감사합니다.  매니저가 확인 후 곧 연락드리겠습니다.")
      },
      message_id,
      fn -> get_message("default") end
    )
  end

  defp get_destination(destination) do
    Map.get_lazy(
      %{
        "/" => %{name: gettext("메인 페이지"), value: "/"}
      },
      destination,
      fn -> get_destination("/") end
    )
  end
end
