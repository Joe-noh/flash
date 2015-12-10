defmodule Flash.RoomChannel do
  use Flash.Web, :channel

  def join("rooms:lobby", _payload, socket) do
    {:ok, %{}, socket}
  end

  def handle_in(_, _, socket) do
    {:noreply, socket}
  end
end
