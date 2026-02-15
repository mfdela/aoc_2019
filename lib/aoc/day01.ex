defmodule Aoc.Day01 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&fuel/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> fuel_with_fuel(0)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def fuel(mass) do
    div(mass, 3) - 2
  end

  def fuel_with_fuel(mass, total_fuel) do
    new_mass =
      mass
      |> Enum.map(&fuel/1)
      |> Enum.filter(&(&1 > 0))

    case Enum.empty?(new_mass) do
      true -> total_fuel
      false -> fuel_with_fuel(new_mass, total_fuel + Enum.sum(new_mass))
    end
  end
end
