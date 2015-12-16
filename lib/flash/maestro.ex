defmodule Flash.Maestro do
  use GenServer

  @room "rooms:lobby"

  defstruct current: nil

  def start_link(scores, offset \\ 0) do
    GenServer.start_link(__MODULE__, [scores, offset])
  end

  def fire(pid) do
    GenServer.call(pid, :fire)
  end

  def current(pid) do
    GenServer.call(pid, :current)
  end

  def init([scores, offset]) do
    forward_sec = Enum.at(scores, offset).start_at

    scores
    |> Enum.drop(offset)
    |> Enum.each fn (score) ->
      Process.send_after(self, {:score, score.detail}, score.start_at - forward_sec)
    end

    {:ok, %__MODULE__{}}
  end

  def handle_call(:fire, _from, state) do
    {:stop, :normal, :fired, state}
  end

  def handle_call(:current, _from, state = %__MODULE__{current: current}) do
    {:reply, current, state}
  end

  def handle_info({:score, detail}, state) do
    Flash.Endpoint.broadcast!(@room, "current", detail)
    {:noreply, %__MODULE__{state | current: detail}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
