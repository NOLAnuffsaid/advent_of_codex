defmodule Mix.Tasks.TwentyFifteen.Day5 do
  use Mix.Task

  @shortdoc """
  --- Day 5: Doesn't He Have Intern-Elves For This? ---
  """

  @doc """
  --- Part One ---

  Santa needs help figuring out which strings in his text file are naughty or nice.

  A nice string is one with all of the following properties:

    - It contains at least three vowels (aeiou only), like aei, xazegov, or
      aeiouaeiouaeiou.
    - It contains at least one letter that appears twice in a row, like xx,
      abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
    - It does not contain the strings ab, cd, pq, or xy, even if they are
      part of one of the other requirements.

  For example:

    - ugknbfddgicrmopn is nice because it has at least three vowels (
      u...i...o...), a double letter (...dd...), and none of the disallowed
      substrings.
    - aaa is nice because it has at least three vowels and a double letter,
      even though the letters used by different rules overlap.
    - jchzalrnumimnmhp is naughty because it has no double letter.
    - haegwjzuvuyypxyu is naughty because it contains the string xy.
    - dvszwmarrgswjxmb is naughty because it contains only one vowel.

  How many strings are nice? 236
  """

  @vowel_regex ~r/[aeiou]/
  @substrings_regex ~r/(ab|cd|pq|xy)/

  @spec run([binary()]) :: integer()
  def run([]), do: :error

  def run([path, "1"]),
    do:
      path
      |> AOC.FileInput.parse()
      |> Enum.reduce(0, fn
        line, count ->
          if(nice?(line), do: count + 1, else: count)
      end)

  def run([path, "2"]),
    do:
      path
      |> AOC.FileInput.parse()
      |> Enum.reduce(0, fn
        line, count ->
          if(new_nice?(line), do: count + 1, else: count)
      end)

  def new_nice?(line) do
    has_double_double?(line) &&
      has_sandwich?(line)
  end

  def nice?(line) do
    has_vowels?(line) &&
      line |> String.codepoints() |> has_double?() &&
      !illegal_substrings?(line)
  end

  def has_vowels?(line),
    do: @vowel_regex |> Regex.scan(line) |> length() > 2

  def has_double?([_ | []]),
    do: false

  def has_double?([lead | rest]),
    do: if(lead == hd(rest), do: true, else: has_double?(rest))

  def illegal_substrings?(line),
    do: Regex.scan(@substrings_regex, line) != []

  @doc """
  --- Part Two ---

  Realizing the error of his ways, Santa has switched to a better model of
  determining whether a string is naughty or nice. None of the old rules
  apply, as they are all clearly ridiculous.

  Now, a nice string is one with all of the following properties:

    - It contains a pair of any two letters that appears at least twice in
      the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but
      not like aaa (aa, but it overlaps).
    - It contains at least one letter which repeats with exactly one letter
      between them, like xyx, abcdefeghi (efe), or even aaa.

  For example:

    - qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj)
      and a letter that repeats with exactly one letter between them (zxz).
    - xxyxx is nice because it has a pair that appears twice and a letter
      that repeats with one between, even though the letters used by each
      rule overlap.
    - uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat
      with a single letter between them.
    - ieodomkazucvgmuy is naughty because it has a repeating letter with one
      between (odo), but no pair that appears twice.

  How many strings are nice under these new rules? 51
  """

  def has_double_double?(line) do
    multi_char_check(line, 2, fn
      chunk ->
        1 <
          chunk
          |> Enum.join()
          |> Regex.compile!()
          |> Regex.scan(line)
          |> length()
    end)
  end

  def has_sandwich?(line) do
    multi_char_check(line, 3, fn
      [a, _, a] -> true
      _ -> false
    end)
  end

  defp multi_char_check(line, num_chars, func) do
    line
    |> String.codepoints()
    |> Enum.chunk_every(num_chars, 1, :discard)
    |> Enum.any?(&func.(&1))
  end
end
