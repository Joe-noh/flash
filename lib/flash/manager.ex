defmodule Flash.Manager do
  use GenServer

  defstruct code: "#fff", period: 500, opacity: 0

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def current do
    GenServer.call __MODULE__, :current
  end

  def change(code = ("#" <> _), period), do: do_change(       code, period)
  def change(code,              period), do: do_change("#" <> code, period)

  defp do_change(code, period) do
    GenServer.cast __MODULE__, {:change, %{code: code, period: period}}
  end

  def opacity(opacity) do
    GenServer.cast __MODULE__, {:opacity, %{opacity: opacity}}
  end

  def sync do
    GenServer.cast __MODULE__, :sync
  end

  def set_alarm(delay, code, period) do
    unixtime = delay + :os.system_time(:seconds)
    GenServer.cast __MODULE__, {:alarm, %{unixtime: unixtime, code: code, period: period}}
  end

  def init(_) do
    {:ok, %__MODULE__{}}
  end

  def handle_call(:current, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:change, params = %{code: code, period: period}}, state) do
    Flash.Endpoint.broadcast! "rooms:lobby", "color:change", params

    {:noreply, %{state | code: code, period: period}}
  end

  def handle_cast(:sync, state) do
    Flash.Endpoint.broadcast! "rooms:lobby", "color:sync", %{}

    {:noreply, state}
  end

  def handle_cast({:opacity, %{opacity: opacity}}, state) do
    Flash.Endpoint.broadcast! "rooms:lobby", "opacity:change", %{opacity: opacity}

    {:noreply, %{state | opacity: opacity}}
  end

  def handle_cast({:alarm, params}, state = %{code: code, period: period}) do
    Flash.Endpoint.broadcast! "rooms:lobby", "timestamp", params

    {:noreply, %{state | code: code, period: period}}
  end
end
