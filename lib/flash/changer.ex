defmodule Flash.Changer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    Process.send_after(self, :tick, 4000)
    {:ok, []}
  end

  def handle_info(:tick, state) do
    Process.send_after(self, :tick, 4000)

    Flash.Endpoint.broadcast! "rooms:lobby", "color:change", %{code: random_color}

    {:noreply, state}
  end

  defp random_color do
    :random.seed(:erlang.now)

    code = ~w[0 1 2 3 4 5 6 7 8 9 a b c d e f] |> Enum.take_random(6)|> Enum.join
    "#" <> code
  end
end
