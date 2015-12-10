defmodule Flash.Maestro do
  use GenServer

  def start_link(scores, offset) do
    GenServer.start_link(__MODULE__, [scores, offset])
  end

  def fire(pid) do
    GenServer.call(pid, :fire)
  end

  def init([scores, offset]) do
    me = self
    Enum.each scores, fn (score) ->
      Process.send_after(me, {:score, score.detail}, score.start_at)
    end

    {:ok, nil}
  end

  def handle_call(:fire, _from, state) do
    {:stop, :normal, :fired, state}
  end

  def handle_info({:score, detail}, state) do
    Flash.Endpoint.broadcast!("rooms:lobby", "current", detail)
    {:noreply, state}
  end

  # def handle_info(_, state) do
  #   {:noreply, state}
  # end
end
