defmodule Aoc.Day07Test do
  use ExUnit.Case

  import Aoc.Day07

  test "example 1: max thruster signal 43210" do
    input = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
    result = part1(input)
    assert result == 43210
  end

  test "example 2: max thruster signal 54321" do
    input = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"
    result = part1(input)
    assert result == 54321
  end

  test "example 3: max thruster signal 65210" do
    input =
      "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"

    result = part1(input)
    assert result == 65210
  end

  test "amplifier chain with specific phase settings" do
    program = parse_input("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
    result = run_amplifier_chain(program, [4, 3, 2, 1, 0])
    assert result == 43210
  end

  test "single amplifier test" do
    program = parse_input("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
    result = run_amplifier(program, 4, 0)
    assert result == 4
  end

  test "permutations generation" do
    result = permutations([1, 2, 3])

    expected = [
      [1, 2, 3],
      [1, 3, 2],
      [2, 1, 3],
      [2, 3, 1],
      [3, 1, 2],
      [3, 2, 1]
    ]

    assert Enum.sort(result) == Enum.sort(expected)
  end

  test "part2 example 1: max feedback loop signal 139629729" do
    input =
      "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"

    result = part2(input)
    assert result == 139_629_729
  end

  test "part2 example 2: max feedback loop signal 18216" do
    input =
      "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"

    result = part2(input)
    assert result == 18216
  end

  test "feedback loop with specific phase settings" do
    program =
      parse_input(
        "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
      )

    result = run_feedback_loop(program, [9, 8, 7, 6, 5])
    assert result == 139_629_729
  end
end
