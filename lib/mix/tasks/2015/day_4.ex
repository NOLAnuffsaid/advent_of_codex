defmodule Mix.Tasks.TwentyFifteen.Day4 do
  use Mix.Task

  @shortdoc "--- Day 4: The Ideal Stocking Stuffer ---"

  @moduledoc """
  Attempts to solve the [Advent Of Code 2015 Day 4 challenge.](https://adventofcode.com/2015/day/4)
  """

  require Logger

  @part_1 {"iwrupvqb", "00000"}
  @part_2 {"iwrupvqb", "000000"}

  @impl Mix.Task
  def run([]) do
    part_2_pid = Task.async(fn -> find_hex(@part_2) end)

    Logger.info("Starting part 1...")
    find_hex(@part_1)

    Logger.info("Starting part 2...")
    Task.await(part_2_pid, 60_000)
  end

  def run(["-p1"]) do
    Logger.info("Starting part 1...")
    find_hex(@part_1)
  end

  def run(["-p2"]) do
    Logger.info("Starting part 2...")
    find_hex(@part_2)
  end

  def run(_),
    do: Logger.error("Invalid arguments!")

  defp find_hex(args) do
    try do
      find_n(args)
    catch
      n when is_integer(n) ->
        Logger.info(n)

      n ->
        Logger.error("Something failed\nCaught Value: #{n}")
    end
  end

  defp find_n({secret, leading_str}),
    do: for(n <- 1..100_000_000_000, "#{secret}#{n}" |> correct_hash?(leading_str), do: throw(n))

  defp correct_hash?(str, expected_start),
    do: str |> hash_str() |> String.starts_with?(expected_start)

  defp hash_str(str),
    do: :crypto.hash(:md5, str) |> Base.encode16()
end
