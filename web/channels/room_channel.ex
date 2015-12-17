defmodule Flash.RoomChannel do
  use Flash.Web, :channel

  @room "rooms:lobby"

  def join(@room, %{"operator" => false}, socket) do
    {:ok, Flash.Manager.current, socket}
  end

  def join(@room, %{"operator" => true}, socket) do
    {:ok, Flash.Manager.scores, socket}
  end

  def handle_in("start", params, socket) do
    params |> Map.get("offset", 0) |> Flash.Manager.start_live()

    {:noreply, socket}
  end

  def handle_in("stop", _params, socket) do
    Flash.Manager.switch_black()
    {:noreply, socket}
  end

  def handle_in(_, _, socket) do
    {:noreply, socket}
  end
end
