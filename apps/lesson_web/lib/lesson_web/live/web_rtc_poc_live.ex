defmodule LessonWeb.WebRTCPocLive do
  use LessonWeb, :live_view
  require Logger
  alias LessonWeb.Presence

  @presence_topic "#{__MODULE__}/presence"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok, _ref} =
        Presence.track(self(), @presence_topic, socket.id, %{pid: self(), offer: false})

      LessonWeb.Endpoint.subscribe(@presence_topic)
      socket = assign_peers(socket)
      {:ok, socket}
    else
      {:ok, assign(socket, :peers, [])}
    end
  end

  @impl true
  def handle_event("send_offer", %{"offer" => offer, "to" => peer_id}, socket) do
    Logger.info("handle_event(\"send_offer\")")

    with {:ok, pid} <- find_peer(peer_id) do
      Logger.info("send(#{inspect(pid)}, %{event: \"offer\"})")
      send(pid, %{event: "offer", offer: offer, sender_id: socket.id})
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("reply_answer", %{"answer" => answer, "to" => peer_id}, socket) do
    Logger.info("handle_event(\"reply_answer\")")

    with {:ok, pid} <- find_peer(peer_id) do
      Logger.info("send(#{inspect(pid)}, %{event: \"reply_answer\"})")
      send(pid, %{event: "reply_answer", answer: answer, sender_id: socket.id})
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("send_ice_candidate", %{"ice_candidate" => ice_candidate, "to" => to}, socket) do
    with {:ok, pid} <- find_peer(to) do
      send(pid, %{event: "ice_candidate", ice_candidate: ice_candidate, sender_id: socket.id})
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("onicecandidateerror", %{"event" => event}, socket) do
    {:noreply, put_flash(socket, :error, event)}
  end

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign_peers(socket)}
  end

  # Get offer from other liveview
  @impl true
  def handle_info(%{event: "offer", offer: offer, sender_id: sender_id}, socket) do
    IO.inspect("Get offer and send it to browser")
    {:noreply, push_event(socket, "offer_from_server", %{"offer" => offer, "from" => sender_id})}
  end

  # Get answer from other liveview
  @impl true
  def handle_info(%{event: "reply_answer", answer: answer, sender_id: sender_id}, socket) do
    IO.puts("Get answer and send it to browser")

    {:noreply,
     push_event(socket, "answer_from_server", %{"answer" => answer, "from" => sender_id})}
  end

  @impl true
  def handle_info(
        %{event: "ice_candidate", ice_candidate: ice_candidate, sender_id: sender_id},
        socket
      ) do
    IO.puts("Get ice_candidate and send it to browser")

    {:noreply,
     push_event(socket, "ice_candidate_from_server", %{
       "ice_candidate" => ice_candidate,
       "from" => sender_id
     })}
  end

  defp assign_peers(socket) do
    peers =
      Presence.list(@presence_topic)
      |> Enum.reject(fn {id, _} -> id == socket.id end)
      |> Map.new()

    IO.puts("#{socket.id} -> #{inspect(Enum.map(peers, &elem(&1, 0)))}")

    assign(socket, :peers, peers)
  end

  defp find_peer(peer_id) do
    with %{metas: [%{pid: pid}]} <- Presence.get_by_key(@presence_topic, peer_id) do
      {:ok, pid}
    else
      _ -> {:error, :peer_not_found}
    end
  end
end
