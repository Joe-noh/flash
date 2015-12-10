defmodule Flash.RoomChannel do
  use Flash.Web, :channel

  def join("rooms:lobby", _payload, socket) do
    {:ok, Flash.Manager.current, socket}
  end

  def handle_in("ping:all", _payload, socket) do
    broadcast socket, "ping", %{}
    {:noreply, socket}
  end

  def handle_in("pong", _payload, socket) do
    IO.puts "got pong"
    {:noreply, socket}
  end

  def handle_in("color:change", %{"code" => code}, socket) do
    Flash.Manager.change(code, 1000)
    {:noreply, socket}
  end

  def handle_in("opacity:change", %{"opacity" => opacity}, socket) do
    Flash.Manager.opacity(opacity)
    {:noreply, socket}
  end

  def handle_in(_, _, socket) do
    {:noreply, socket}
  end
end
