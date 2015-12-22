defmodule Flash.Manager do
  use GenServer

  import Flash.Helpers

  # きゃりー用
  @skyblue "#99ffff"
  @yellow  "#fcea90"
  @pink    "#ff99c7"

  # pia-no-jac用
  @p_brown  "#572900"
  @p_orange "#f78e1e"
  @p_yellow "#ffdd00"
  @p_green  "#00b5ad"
  @p_red    "#ff3e42"

  # マライア用
  @red   "#ee0404"
  @green "#148f13"

  @white "#ffffff"
  @black "#101010"

  def scores do
    [
      circle_cycle(31, [@p_orange, @p_yellow, @p_green, @p_red], bpm_to_period(85), bpm_to_period(100), 0),

      switch_cycle(31, [@pink, @yellow, @skyblue], bpm_to_period(145), 10000),
      fade_cycle(  31, [@yellow, @skyblue, @pink], bpm_to_period(145), offset(145, 31)),

      slide_cycle(31, [@p_orange, @p_yellow, @p_green, @p_red], bpm_to_period(85), bpm_to_period(170), 25500),

      switch_random_cycle(50, [@red, @green, @white], bpm_to_period(75), offset(145, 31)*2 + offset(170, 124)),
      {110000, :rainbow},
      {123000, :shade, 27000}
    ] |> List.flatten |> Enum.map(&expand_score/1)
  end

  def black_out_scores do
    [
      {  10, :switch, @black},
      {1000, :switch, @black}
    ] |> Enum.map(&expand_score/1)
  end

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
end
