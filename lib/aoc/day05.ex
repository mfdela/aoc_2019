defmodule Aoc.Day05 do
  def part1(args) do
    program = parse_input(args)
    program = Map.put(program, :input, 1)
    result = run_program(program)
    result[:output]
  end

  def part2(args) do
    program = parse_input(args)
    program = Map.put(program, :input, 5)
    result = run_program(program)
    result[:output]
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
    instruction = program[pc]
    opcode = rem(instruction, 100)
    modes = div(instruction, 100)

    case opcode do
      99 ->
        program

      1 ->
        # Add
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))
        dest = program[pc + 3]

        Map.put(program, dest, param1 + param2)
        |> run_program(pc + 4)

      2 ->
        # Multiply
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))
        dest = program[pc + 3]

        Map.put(program, dest, param1 * param2)
        |> run_program(pc + 4)

      3 ->
        # Input
        dest = program[pc + 1]
        Map.put(program, dest, program[:input])
        |> run_program(pc + 2)

      4 ->
        # Output
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        Map.put(program, :output, param1)
        |> run_program(pc + 2)

      5 ->
        # Jump-if-true
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))

        if param1 != 0 do
          run_program(program, param2)
        else
          run_program(program, pc + 3)
        end

      6 ->
        # Jump-if-false
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))

        if param1 == 0 do
          run_program(program, param2)
        else
          run_program(program, pc + 3)
        end

      7 ->
        # Less than
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))
        dest = program[pc + 3]

        value = if param1 < param2, do: 1, else: 0
        Map.put(program, dest, value)
        |> run_program(pc + 4)

      8 ->
        # Equals
        param1 = get_param(program, pc + 1, get_mode(modes, 0))
        param2 = get_param(program, pc + 2, get_mode(modes, 1))
        dest = program[pc + 3]

        value = if param1 == param2, do: 1, else: 0
        Map.put(program, dest, value)
        |> run_program(pc + 4)
    end
  end

  def get_param(program, addr, mode) do
    case mode do
      0 -> program[program[addr]]  # Position mode
      1 -> program[addr]            # Immediate mode
    end
  end

  def get_mode(modes, position) do
    modes
    |> div(Integer.pow(10, position))
    |> rem(10)
  end
end
