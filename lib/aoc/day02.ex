defmodule Aoc.Day02 do
  def part1(args) do
    args
    |> parse_input()
    |> Map.put(1, 12)
    |> Map.put(2, 2)
    |> run_program()
    |> Map.get(0)
  end

  def part2(args) do
    target = 19690720
    program = parse_input(args)

    for noun <- 0..99, verb <- 0..99 do
      result =
        program
        |> Map.put(1, noun)
        |> Map.put(2, verb)
        |> run_program()
        |> Map.get(0)

      if result == target do
        {noun, verb}
      end
    end
    |> Enum.find(&(&1 != nil))
    |> then(fn {noun, verb} -> 100 * noun + verb end)
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end

  def run_program(program), do: run_program(program, 0)

  def run_program(program, pc) do

    opcode = program[pc]

    case opcode do
      99 ->
        program

      1 ->
        Map.put(program, program[pc + 3], program[program[pc + 1]] + program[program[pc + 2]])
        |>run_program(pc + 4)

      2 ->

        Map.put(program, program[pc + 3], program[program[pc + 1]] * program[program[pc + 2]])
        |>run_program(pc + 4)
    end
  end
end
