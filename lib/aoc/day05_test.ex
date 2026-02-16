defmodule Aoc.Day05Test do
  use ExUnit.Case

  import Elixir.Aoc.Day05

  def test_input() do
    ""
  end

  test "parameter mode example" do
    # Example from spec: 1002,4,3,4,33
    # Should multiply position 4 (33) by immediate 3 and store at position 4
    program = parse_input("1002,4,3,4,33")
    result = run_program(program)

    assert result[4] == 99
  end

  # test "part1" do
  #   input = test_input()
  #   result = part1(input)

  #   assert result
  # end

  test "equals position mode - input equals 8" do
    program = parse_input("3,9,8,9,10,9,4,9,99,-1,8")
    program = Map.put(program, :input, 8)
    result = run_program(program)
    assert result[:output] == 1
  end

  test "equals position mode - input not equals 8" do
    program = parse_input("3,9,8,9,10,9,4,9,99,-1,8")
    program = Map.put(program, :input, 7)
    result = run_program(program)
    assert result[:output] == 0
  end

  test "less than position mode - input less than 8" do
    program = parse_input("3,9,7,9,10,9,4,9,99,-1,8")
    program = Map.put(program, :input, 7)
    result = run_program(program)
    assert result[:output] == 1
  end

  test "less than position mode - input not less than 8" do
    program = parse_input("3,9,7,9,10,9,4,9,99,-1,8")
    program = Map.put(program, :input, 8)
    result = run_program(program)
    assert result[:output] == 0
  end

  test "equals immediate mode - input equals 8" do
    program = parse_input("3,3,1108,-1,8,3,4,3,99")
    program = Map.put(program, :input, 8)
    result = run_program(program)
    assert result[:output] == 1
  end

  test "less than immediate mode - input less than 8" do
    program = parse_input("3,3,1107,-1,8,3,4,3,99")
    program = Map.put(program, :input, 7)
    result = run_program(program)
    assert result[:output] == 1
  end

  test "jump test position mode - input zero" do
    program = parse_input("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9")
    program = Map.put(program, :input, 0)
    result = run_program(program)
    assert result[:output] == 0
  end

  test "jump test position mode - input non-zero" do
    program = parse_input("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9")
    program = Map.put(program, :input, 5)
    result = run_program(program)
    assert result[:output] == 1
  end

  test "jump test immediate mode - input zero" do
    program = parse_input("3,3,1105,-1,9,1101,0,0,12,4,12,99,1")
    program = Map.put(program, :input, 0)
    result = run_program(program)
    assert result[:output] == 0
  end

  test "jump test immediate mode - input non-zero" do
    program = parse_input("3,3,1105,-1,9,1101,0,0,12,4,12,99,1")
    program = Map.put(program, :input, 5)
    result = run_program(program)
    assert result[:output] == 1
  end

  test "large example - input below 8" do
    program =
      parse_input(
        "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
      )

    program = Map.put(program, :input, 7)
    result = run_program(program)
    assert result[:output] == 999
  end

  test "large example - input equals 8" do
    program =
      parse_input(
        "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
      )

    program = Map.put(program, :input, 8)
    result = run_program(program)
    assert result[:output] == 1000
  end

  test "large example - input above 8" do
    program =
      parse_input(
        "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
      )

    program = Map.put(program, :input, 9)
    result = run_program(program)
    assert result[:output] == 1001
  end

  # test "part2" do
  #   input = test_input()
  #   result = part2(input)

  #   assert result
  # end
end
