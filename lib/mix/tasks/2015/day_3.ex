defmodule Mix.Tasks.TwentyFifteen.Day3 do
  use Mix.Task

  @shortdoc "Advent Of Code 2015 Day 3"

  @moduledoc """
  Attempts to solve the [Advent Of Code 2015 Day 3 challenge.](https://adventofcode.com/2015/day/3)
  """

  require Logger

  @impl Mix.Task
  def run([]), do: {:error, :noargs}

  def run([file_path, "-p1"]) do
    Logger.info("Starting 2015 Day 3 Phase 1...")

    file_path
    |> AOC.FileInput.parse()
    |> Enum.flat_map(&String.to_charlist/1)
    |> deliver_presents()
    |> Enum.uniq()
    |> Enum.count()
    |> Logger.info()
  end

  def run([file_path, "-p2"]) do
    Logger.info("Starting 2015 Day 3 Phase 2...")

    file_path
    |> AOC.FileInput.parse()
    |> Enum.flat_map(&String.to_charlist/1)
    |> count_split_delivery()
    |> Logger.info()
  end

  def count_split_delivery([_h | tail] = all_chars) do
    [all_chars, tail]
    |> Enum.map(fn chars ->
      Task.async(fn
        ->
          chars
          |> Enum.take_every(2)
          |> deliver_presents()
      end)
    end)
    |> Enum.flat_map(&Task.await/1)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp deliver_presents(chars) do
    chars
    |> Enum.reduce([{0,0}], fn
      char, coords_list ->
        last_coord = List.last(coords_list)
        coords_list ++ [move_santa(char, last_coord)]
    end)
    |> Enum.uniq()
  end

  # use a coordinate system {v, h} where:
  #   v =                h =
  #     Up = +1            Right = +1
  #     Down = -1          Left = -1
  #
  # each move adds a new coordinate to a history
  # after each move we check the history for that coordinate:
  #   history has coord? : we've visited
  #            no coord? : first time visit
  defp move_santa(60, {v, h}), do: {v, h - 1}
  defp move_santa(62, {v, h}), do: {v, h + 1}
  defp move_santa(118, {v, h}), do: {v - 1, h}
  defp move_santa(94, {v, h}), do: {v + 1, h}
end
