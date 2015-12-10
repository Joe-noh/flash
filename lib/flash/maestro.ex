defmodule Flash.Maestro do
  use GenServer

  @room "rooms:lobby"

  def start_link(scores, offset \\ 0) do
    GenServer.start_link(__MODULE__, [scores, offset])
  end

  def fire(pid) do
    GenServer.call(pid, :fire)
  end

  def init([scores, offset]) do
    scores
    |> Enum.drop(offset)
    |> Enum.each fn (score) ->
      Process.send_after(self, {:score, score.detail}, score.start_at)
    end

    {:ok, nil}
  end

  def handle_call(:fire, _from, state) do
    {:stop, :normal, :fired, state}
  end

  def handle_info({:score, detail}, state) do
    Flash.Endpoint.broadcast!(@room, "current", detail)
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
