defmodule Flash.Manager do
  use GenServer

  @skyblue "#6fe3fc"
  @blue   "#22A7F0"
  @pink  "#fd92be"
  @black  "#101010"

  expand_score = fn
    {start_at, :switch, color} ->
      %{start_at: start_at, detail: %{type: :switch, color: color}}
    {start_at, :fade, color, duration} ->
      %{start_at: start_at, detail: %{type: :switch, color: color, duration: duration}}
    {start_at, :rainbow} ->
      %{start_at: start_at, detail: %{type: :rainbow}}
  end

  @scores [
    {   10, :switch, @pink},
    { 1000, :switch, @skyblue},
    { 2000, :switch, @pink},
    { 3000, :switch, @skyblue},
    { 4000, :switch, @pink},
    { 5000, :switch, @skyblue},
    { 6000, :switch, @pink},
    { 7000, :switch, @skyblue},
    { 8000, :switch, @pink},
    { 9000, :switch, @skyblue},
    {10000, :fade,   @pink,  2000},
    {12000, :fade,   @pink, 4000},
    {16000, :fade,   @skyblue, 4000},
    {20000, :fade,   @black, 1000},
    {22000, :fade,   @black, 2000},
    {23000, :rainbow}
  ] |> Enum.map(expand_score)

  @black_out [
    {10, :switch,@black},
    {1000, :switch,@black}
  ] |> Enum.map(expand_score)

  defstruct maestro: nil

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_live(offset) do
    GenServer.cast __MODULE__, {:start_live, offset}
  end

  def scores, do: @scores

  def current do
    GenServer.call __MODULE__, :current
  end

  def switch_black do
    GenServer.cast __MODULE__, :switch_black
  end

  def change_color(color) do
    GenServer.cast __MODULE__, {:change_color, color}
  end

  def init(_) do
    {:ok, pid} = Flash.Maestro.start_link([
      %{start_at: 0, detail: %{type: :switch, color: @black}}
    ])

    {:ok, %__MODULE__{maestro: pid}}
  end

  def handle_cast({:change_color, color}, state = %{maestro: pid}) do
    Flash.Maestro.change_color(pid, color)
    {:noreply, state}
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

  def handle_cast(:switch_black, state = %{maestro: nil}) do
    {:ok, pid} = Flash.Maestro.start_link(@black_out)

    {:noreply, %{state | maestro: pid}}
  end

  def handle_cast(:switch_black, state = %{maestro: pid}) do
    :fired = Flash.Maestro.fire(pid)
    {:ok, new_pid} = Flash.Maestro.start_link(@black_out)

    {:noreply, %{state | maestro: new_pid}}
  end

  def handle_call(:current, _from, state = %{maestro: nil}) do
    {:reply, %{}, state}
  end

  def handle_call(:current, _from, state = %{maestro: pid}) do
    {:reply, Flash.Maestro.current(pid), state}
  end
end
