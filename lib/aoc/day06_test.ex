defmodule Aoc.Day06Test do
  use ExUnit.Case

  import Elixir.Aoc.Day06

  def test_input() do
    """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 42
  end

  test "part2" do
    input = """
    COM)B
    B)C
    C)D
    D)E
    E)F
       B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    K)YOU
    I)SAN
    """

    result = part2(input)

    assert result == 4
  end
end
