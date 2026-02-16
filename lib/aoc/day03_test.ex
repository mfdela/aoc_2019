defmodule Aoc.Day03Test do
  use ExUnit.Case

  import Elixir.Aoc.Day03

  def test_input() do
    """
    R8,U5,L5,D3
    U7,R6,D4,L4
    """
  end

  def test_input2() do
    """
    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83
    """
  end

  def test_input3() do
    """
    R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
    U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
    """
    end

    test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 6
    end

    test "part1 example 2" do
    input = test_input2()
    result = part1(input)

    assert result == 159
  end
  
  test "part1 example 3" do
      input = test_input3()
    result = part1(input)

    assert result == 135
  end
  
  test "part2" do
      input = test_input()
    result = part2(input)

    assert result == 30
  end

  test "part2 example 2" do
    input = test_input2()
    result = part2(input)

    assert result == 610
  end

  test "part2 example 3" do
    input = test_input3()
    result = part2(input)

    assert result == 410
  end
end
