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

  def slide_cycle(count, colors, period, duration, start_at) do
    length = length(colors)
    Enum.map 0..count-1, fn i ->
      color = Enum.at(colors, rem(i, length))
      {start_at + period*i, :slide, color, duration}
    end
  end

  def circle_cycle(count, colors, period, duration, start_at) do
    length = length(colors)
    Enum.map 0..count-1, fn i ->
      color = Enum.at(colors, rem(i, length))
      {start_at + period*i, :circle, color, duration}
    end
  end

  def expand_score({start_at, :switch, color}) do
    %{start_at: start_at, detail: %{type: :switch, color: color}}
  end

  def expand_score({start_at, :rainbow}) do
    %{start_at: start_at, detail: %{type: :rainbow}}
  end

  def expand_score({start_at, type, duration}) when is_number(duration) do
    %{start_at: start_at, detail: %{type: type, duration: duration}}
  end

  def expand_score({start_at, type, colors}) do
    %{start_at: start_at, detail: %{type: type, colors: colors}}
  end

  def expand_score({start_at, type, color, duration}) do
    %{start_at: start_at, detail: %{type: type, color: color, duration: duration}}
  end

  def bpm_to_period(bpm), do: round(60000 / bpm)

  def offset(bpm, count), do: count * bpm_to_period(bpm)
end
