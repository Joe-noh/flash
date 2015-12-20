defmodule Flash.Manager do
  use GenServer

  import Flash.Helpers

  @skyblue "#6fe3fc"
  @blue    "#22a7f0"
  @pink    "#fd92be"
  @black   "#101010"

  defstruct maestro: nil

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_live(offset) do
    GenServer.cast __MODULE__, {:start_live, offset}
  end

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
    {:ok, pid} = Flash.Maestro.start_link [
      %{start_at: 0, detail: %{type: :switch, color: @black}}
    ]

    {:ok, %__MODULE__{maestro: pid}}
  end

  def handle_cast({:change_color, color}, state = %{maestro: pid}) do
    Flash.Maestro.change_color(pid, color)
    {:noreply, state}
  end

  def handle_cast({:start_live, offset}, state = %{maestro: nil}) do
    {:ok, pid} = Flash.Maestro.start_link(scores, offset)

    {:noreply, %{state | maestro: pid}}
  end

  def handle_cast({:start_live, offset}, state = %{maestro: pid}) do
    :fired = Flash.Maestro.fire(pid)
    {:ok, new_pid} = Flash.Maestro.start_link(scores, offset)

    {:noreply, %{state | maestro: new_pid}}
  end

  def handle_cast(:switch_black, state = %{maestro: pid}) do
    :fired = Flash.Maestro.fire(pid)
    {:ok, new_pid} = Flash.Maestro.start_link(black_out_scores)

    {:noreply, %{state | maestro: new_pid}}
  end

  def handle_call(:current, _from, state = %{maestro: pid}) do
    {:reply, Flash.Maestro.current(pid), state}
  end

  def scores do
    [
      switch_cycle(20, [@pink, @skyblue, @blue], bpm_to_period(170), 0),
      fade_cycle(  30, [@pink, @skyblue, @blue], bpm_to_period(145), offset(170, 20))
    ] |> List.flatten |> Enum.map(&expand_score/1)
  end

  def black_out_scores do
    [
      {  10, :switch, @black},
      {1000, :switch, @black}
    ] |> Enum.map(&expand_score/1)
  end
end
