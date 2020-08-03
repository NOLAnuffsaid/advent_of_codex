defmodule Mix.Tasks.TwentyFifteen.Day2 do
  use Mix.Task

  @shortdoc "--- Day 2: I Was Told There Would Be No Math ---"

  @moduledoc """
  Attempts to solve the [Advent Of Code 2015 Day 2 challenge.](https://adventofcode.com/2015/day/2)

  ## Example

  mix twenty_fifteen.day2 input_file [-p1 | -p2 | -p3 | .... | -pn]
  """

  require Logger

  @impl Mix.Task
  def run([]), do: {:error, :noargs}

  @doc """
  ## Example

    iex> mix twenty_fifteen.day2 ./resources/2015_day2.txt -p1
    :30:12.632 [info]  1606483
  """
  def run([file_path, "-p1"]) do
    file_path
    |> AOC.FileInput.parse([])
    |> Stream.map(&split_line/1)
    |> Enum.reduce(0, fn
      measurements, acc ->
        acc + calc_paper_length(measurements)
    end)
    |> Logger.info()
  end

  @doc """
  ## Example

    iex> mix twenty_fifteen.day2 ./resources/2015_day2.txt -p2
    17:30:21.250 [info]  3842356
  """
  def run([file_path, "-p2"]) do
    file_path
    |> AOC.FileInput.parse([])
    |> Stream.map(&split_line/1)
    |> Enum.reduce(0, fn
      measurements, acc ->
        acc + calc_ribbon_and_bow_length(measurements)
    end)
    |> Logger.info()
  end

  def run(_), do: {:error, :invalidargs}

  defp split_line(line), do: line |> String.trim() |> String.split("x")

  defp calc_paper_length(measurements) do
    [l, w, h] = Enum.map(measurements, &String.to_integer/1)
    surface_areas = [l * w, w * h, h * l]
    min_surface = Enum.min(surface_areas)

    sqr_ft =
      surface_areas
      |> Enum.map(&(&1 * 2))
      |> Enum.sum()

    sqr_ft + min_surface
  end

  defp calc_ribbon_and_bow_length(measurements) do
    [a, b, c] = measurements |> Enum.map(&String.to_integer/1) |> Enum.sort()
    ribbon_length = (a + b) * 2
    bow_length = a * b * c

    ribbon_length + bow_length
  end
end
