defmodule Flash.Manager do
  use GenServer

  import Flash.Helpers

  # きゃりー用
  @skyblue "#99ffff"
  @yellow  "#fcea90"
  @pink    "#ff99c7"

  # pia-no-jac slide用
  @s_blue   "#00aedb"
  @s_purple "#a200ff"
  @s_orange "#f47835"
  @s_red    "#d41243"
  @s_green  "#8ec127"

  # pia-no-jac circle用
  @c_red    "#d11141"
  @c_green  "#00aa49"
  @c_blue   "#11b3ff"
  @c_orange "#f37735"
  @c_yellow "#ffc425"

  # マライア用
  @red   "#d01212"
  @green "#215a22"
  @gold  "#d5d404"

  @white "#ffffff"
  @black "#101010"

  def scores do
    [
      switch_cycle(31, [@pink, @yellow, @skyblue], bpm_to_period(145), 10),
      fade_cycle(  31, [@yellow, @skyblue, @pink], bpm_to_period(145), offset(145, 31)),

      slide_cycle(30, [@s_blue, @s_purple, @s_orange, @s_red, @s_green],  bpm_to_period(85), bpm_to_period(170), 25500),
      circle_cycle(32, [@c_red, @c_green, @c_blue, @c_orange, @c_yellow], bpm_to_period(85), bpm_to_period(110), 25500 + offset(85, 30)),

      switch_random_cycle(50, [@red, @green, @gold], bpm_to_period(75), 25500 + offset(85, 62)),
      {110000, :rainbow},
      {120000, :shade, 24000}
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
