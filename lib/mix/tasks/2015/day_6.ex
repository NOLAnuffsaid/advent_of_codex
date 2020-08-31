defmodule Mix.Tasks.TwentyFifteen.Day6 do
  use Mix.Task

  alias AOC.FileInput

  require IEx

  @line_regex ~r/^(turn off|turn on|toggle)\s(\d{1,3},\d{1,3})\sthrough\s(\d{1,3},\d{1,3})$/

  @shortdoc "--- Day 6: Probably a Fire Hazard ---"

  @moduledoc """
  --- Part One ---

  Because your neighbors keep defeating you in the holiday house decorating
  contest year after year, you've decided to deploy one million lights in a
  1000x1000 grid.

  Furthermore, because you've been especially nice this year, Santa has
  mailed you instructions on how to display the ideal lighting configuration.

  Lights in your grid are numbered from 0 to 999 in each direction; the
  lights at each corner are at 0,0, 0,999, 999,999, and 999,0. The
  instructions include whether to turn on, turn off, or toggle various
  inclusive ranges given as coordinate pairs. Each coordinate pair represents
  opposite corners of a rectangle, inclusive; a coordinate pair like
  0,0 through 2,2 therefore refers to 9 lights in a 3x3 square. The lights
  all start turned off.

  To defeat your neighbors this year, all you have to do is set up your
  lights by doing the instructions Santa sent you in order.

    For example:

      - turn on 0,0 through 999,999 would turn on (or leave on) every light.
      - toggle 0,0 through 999,0 would toggle the first line of 1000 lights,
        turning off the ones that were on, and turning on the ones that were
        off.
      - turn off 499,499 through 500,500 would turn off (or leave off) the
        middle four lights.

    After following the instructions, how many lights are lit?

  --- Part Two ---

  You just finish implementing your winning light pattern when you realize
  you mistranslated Santa's message from Ancient Nordic Elvish.

  The light grid you bought actually has individual brightness controls; each
  light can have a brightness of zero or more. The lights all start at zero.

  The phrase turn on actually means that you should increase the brightness
  of those lights by 1.

  The phrase turn off actually means that you should decrease the brightness
  of those lights by 1, to a minimum of zero.

  The phrase toggle actually means that you should increase the brightness of
  those lights by 2.

  What is the total brightness of all lights combined after following Santa's instructions?

  For example:

    - turn on 0,0 through 0,0 would increase the total brightness by 1.
    - toggle 0,0 through 999,999 would increase the total brightness by
      2000000.
  """


  @doc """
  Update this solution:
    - Build grid with default values ( p1 => false, p2 => 0 )
  """
  @impl Mix.Task
  def run([]), do: :error

  def run([file_path, "-p1"]) do
    file_path
    |> FileInput.parse()
    |> Enum.reduce(%{}, fn
      line, active_lights ->
        line
        |> parse_line()
        |> manipulate_lights(active_lights)
    end)
    |> Enum.reduce(0, fn {_k, v}, sum -> if(v, do: sum + 1, else: sum) end)
    |> IO.puts()
  end

  def run([file_path, "-p2"]) do
    file_path
    |> FileInput.parse()
    |> Enum.reduce(%{}, fn
      line, lights ->
        line
        |> parse_line()
        |> control_brightness(lights)
    end)
    |> Enum.reduce(0, fn {_k, v}, sum -> sum + v end)
    |> IO.puts()
  end

  def control_brightness(["turn on", left_coord, right_coord], lights) do
    {left_x, left_y} = decode(left_coord)
    {right_x, right_y} = decode(right_coord)

    Map.merge(
      lights,
      for x <- left_x..right_x,
          y <- left_y..right_y,
          into: %{} do
        {encode({x, y}), 1}
      end,
      fn _k, v1, v2 -> v1 + v2 end
    )
  end

  def control_brightness(["turn off", left_coord, right_coord], lights) do
    {left_x, left_y} = decode(left_coord)
    {right_x, right_y} = decode(right_coord)

    Map.merge(
      lights,
      for x <- left_x..right_x,
          y <- left_y..right_y,
          into: %{} do
        {encode({x, y}), 0}
      end,
      fn _k, v1, _v2 -> if(v1 == 0, do: 0, else: v1 - 1) end
    )
  end

  def control_brightness(["toggle", left_coord, right_coord], lights) do
    {left_x, left_y} = decode(left_coord)
    {right_x, right_y} = decode(right_coord)

    Map.merge(
      lights,
      for x <- left_x..right_x,
          y <- left_y..right_y,
          into: %{} do
        {encode({x, y}), 2}
      end,
      fn _k, v1, _v2 -> v1 + 2 end
    )
  end

  def parse_line(line),
    do:
      @line_regex
      |> Regex.run(line)
      |> tl()

  def manipulate_lights(["turn on", left_coord, right_coord], lights) do
    {left_x, left_y} = decode(left_coord)
    {right_x, right_y} = decode(right_coord)

    Map.merge(
      lights,
      for x <- left_x..right_x,
          y <- left_y..right_y,
          into: %{} do
        {encode({x, y}), true}
      end
    )
  end

  def manipulate_lights(["turn off", left_coord, right_coord], lights) do
    {left_x, left_y} = decode(left_coord)
    {right_x, right_y} = decode(right_coord)

    Map.merge(
      lights,
      for x <- left_x..right_x,
          y <- left_y..right_y,
          into: %{} do
        {encode({x, y}), false}
      end
    )
  end

  def manipulate_lights(["toggle", left_coord, right_coord], lights) do
    {left_x, left_y} = decode(left_coord)
    {right_x, right_y} = decode(right_coord)

    Map.merge(
      lights,
      for x <- left_x..right_x,
          y <- left_y..right_y,
          into: %{} do
        {encode({x, y}), true}
      end,
      fn _k, v1, _v2 -> !v1 end
    )
  end

  def decode(coord),
    do:
      coord
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

  def encode({x, y}),
    do: "#{x},#{y}"
end
