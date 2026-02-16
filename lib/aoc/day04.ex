defmodule Aoc.Day04 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.filter(&is_valid_password/1)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.filter(&is_valid_password_part2/1)
    |> Enum.count()
  end

  def parse_input(input) do
    [min, max] = String.split(input, "-", trim: true) |> Enum.map(&String.to_integer/1)
    Enum.to_list(min..max)
  end

  def digits(number) do
    Integer.digits(number)
  end

  def is_valid_password(password) do
    digits = digits(password)

    Enum.chunk_every(digits, 2, 1, :discard) |> Enum.any?(&(&1 == [hd(&1), hd(&1)])) and
      Enum.sort(digits) == digits
  end

  def is_valid_password_part2(password) do
    digits = digits(password)

    has_exact_double =
      digits
      |> Enum.chunk_by(& &1)
      |> Enum.any?(fn group -> length(group) == 2 end)

    has_exact_double and Enum.sort(digits) == digits
  end
end
