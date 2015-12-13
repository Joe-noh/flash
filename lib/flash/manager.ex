defmodule Flash.Manager do
  use GenServer

  @scores [
    %{start_at:    10, detail: %{type: :fade, color: "#144", duration: 1000}},
    %{start_at:  5000, detail: %{type: :switch, color: "#944"}},
    %{start_at: 10000, detail: %{type: :fade, color: "#000", duration: 10000}},
    %{start_at: 20000, detail: %{type: :fade, color: "#fff", duration: 10000}},
    %{start_at: 30000, detail: %{type: :rainbow}}
  ]

  defstruct maestro: nil

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_live(offset) do
    GenServer.cast __MODULE__, {:start_live, offset}
  end

  def scores(), do: @scores

  def init(_) do
    {:ok, %__MODULE__{}}
  end

  def handle_cast({:start_live, offset}, state = %{maestro: nil}) do
    {:ok, pid} = Flash.Maestro.start_link(@scores, offset)

    {:noreply, %{state | maestro: pid}}
  end

  def handle_cast({:start_live, offset}, state = %{maestro: pid}) do
    :fired = Flash.Maestro.fire(pid)
    {:ok, new_pid} = Flash.Maestro.start_link(@scores, offset)

    {:noreply, %{state | maestro: new_pid}}
  end
end
