defmodule Flash.RoomChannel do
  use Flash.Web, :channel

  def join("rooms:lobby", payload, socket) do
    {:ok, Flash.Manager.current, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", _payload, socket) do
    broadcast socket, "pong", %{}
    {:noreply, socket}
  end
end
