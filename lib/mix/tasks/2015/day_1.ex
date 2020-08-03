defmodule Mix.Tasks.TwentyFifteen.Day1 do
  use Mix.Task

  @shortdoc "--- Day 1: Not Quite Lisp ---"

  @moduledoc """
  Attempts to solve the [Advent Of Code 2015 Day 1 challenge.](https://adventofcode.com/2015/day/1)

  ## Example

  mix twenty_fifteen.day1 input_file [-p1 | -p2 | -p3 | .... | -pn]
  """

  require Logger

  @impl Mix.Task
  def run([]), do: {:error, :noargs}

  @doc """
  ## Example

    iex> mix twenty_fifteen.day1 ./resources/2015_day1.txt -p1
    17:28:40.825 [info]  232
  """
  def run([file_path, "-p1"]) do
    file_path
    |> AOC.FileInput.parse(as: :stream)
    |> Enum.reduce(0, &find_next_floor/2)
    |> Logger.info()
  end

  @doc """
  ## Example

    iex> mix twenty_fifteen.day1 ./resources/2015_day1.txt -p2
    17:29:32.888 [info]  1783
  """
  def run([file_path, "-p2"]) do
    file_path
    |> AOC.FileInput.parse(as: :stream)
    |> Enum.reduce_while({0, 0}, &find_basement_pos/2)
    |> Logger.info()
  end

  def run(_), do: {:error, :invalidargs}

  defp find_basement_pos("(", {floor, pos}), do: {:cont, {floor + 1, pos + 1}}
  defp find_basement_pos(")", {0, pos}), do: {:halt, pos + 1}
  defp find_basement_pos(")", {floor, pos}), do: {:cont, {floor - 1, pos + 1}}

  defp find_next_floor("(", floor), do: floor + 1
  defp find_next_floor(")", floor), do: floor - 1
  defp find_next_floor(_, acc), do: acc
end
