defmodule Flash.Manager do
  use GenServer

  defstruct code: "#fff", period: 500

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def current do
    GenServer.call __MODULE__, :current
  end

  def change(code = ("#" <> _), period), do: do_change(       code, period)
  def change(code,              period), do: do_change("#" <> code, period)

  defp do_change(code, period) do
    GenServer.cast __MODULE__, {:change, [code: code, period: period]}
  end

  def sync do
    GenServer.cast __MODULE__, :sync
  end

  def init(_) do
    {:ok, %__MODULE__{}}
  end

  def handle_call(:current, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:change, [code: code, period: period]}, state) do
    Flash.Endpoint.broadcast! "rooms:lobby", "color:change", %{code: code, period: period}

    {:noreply, %{state | code: code, period: period}}
  end

  def handle_cast(:sync, state) do
    Flash.Endpoint.broadcast! "rooms:lobby", "color:sync", %{}

    {:noreply, state}
  end
end
