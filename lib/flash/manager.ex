defmodule Flash.Manager do
  use GenServer

  @yellow "#f1c40f"
  @blue   "#22A7F0"
  @pink   "#D2527F"
  @white  "#ecf0f1"
  @black  "#101010"

  @scores [
    %{start_at:    10, detail: %{type: :switch, color: @white}},
    %{start_at:  1000, detail: %{type: :switch, color: @yellow}},
    %{start_at:  2000, detail: %{type: :switch, color: @white}},
    %{start_at:  3000, detail: %{type: :switch, color: @yellow}},
    %{start_at:  4000, detail: %{type: :switch, color: @white}},
    %{start_at:  5000, detail: %{type: :switch, color: @yellow}},
    %{start_at:  6000, detail: %{type: :switch, color: @white}},
    %{start_at:  7000, detail: %{type: :switch, color: @yellow}},
    %{start_at:  8000, detail: %{type: :switch, color: @white}},
    %{start_at:  9000, detail: %{type: :switch, color: @yellow}},
    %{start_at: 10000, detail: %{type: :fade,   color: @pink,   duration: 2000}},
    %{start_at: 12000, detail: %{type: :fade,   color: @white,  duration: 4000}},
    %{start_at: 16000, detail: %{type: :fade,   color: @yellow, duration: 4000}},
    %{start_at: 20000, detail: %{type: :fade,   color: @black,  duration: 1000}},
    %{start_at: 22000, detail: %{type: :fade,   color: @black,  duration: 2000}},
    %{start_at: 23000, detail: %{type: :rainbow}}
  ]

  @black_out [
    %{start_at:   10, detail: %{type: :switch, color: @black}},
    %{start_at: 1000, detail: %{type: :switch, color: @black}}
  ]

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
