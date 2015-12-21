defmodule Flash.Helpers do
  @doc """
  :switchアクションを繰り返し生成する
  """
  def switch_cycle(count, colors, period, start_at) do
    length = length(colors)
    Enum.map 0..count-1, fn i ->
      color = Enum.at(colors, rem(i, length))
      {start_at + period*i, :switch, color}
    end
  end

  @doc """
  :fadeアクションを繰り返し生成する
  """
  def fade_cycle(count, colors, period, start_at) do
    length = length(colors)
    Enum.map 0..count-1, fn i ->
      color = Enum.at(colors, rem(i, length))
      {start_at + period*i, :fade, color, period}
    end
  end

  def switch_random_cycle(count, colors, period, start_at) do
    Enum.map 0..count-1, fn i ->
      {start_at + period*i, :switch_random, colors}
    end
  end

  def expand_score({start_at, :switch, color}) do
    %{start_at: start_at, detail: %{type: :switch, color: color}}
  end

  def expand_score({start_at, :fade, color, duration}) do
    %{start_at: start_at, detail: %{type: :fade, color: color, duration: duration}}
  end

  def expand_score({start_at, :switch_random, colors}) do
    %{start_at: start_at, detail: %{type: :switch_random, colors: colors}}
  end

  def expand_score({start_at, :rainbow}) do
    %{start_at: start_at, detail: %{type: :rainbow}}
  end

  def expand_score({start_at, :shade, duration}) do
    %{start_at: start_at, detail: %{type: :shade, duration: duration}}
  end

  def bpm_to_period(bpm), do: round(60000 / bpm)

  def offset(bpm, count), do: count * bpm_to_period(bpm)
end
