defmodule Aoc.Day03 do
  def part1(args) do
    args
    |> parse_input()
    |> find_intersections()
    |> Enum.map(fn {r, c} -> abs(r) + abs(c) end)
    |> Enum.min()

    # |> Enum.min_by(&distance_to_origin/1)
  end

  def part2(args) do
    args
    |> parse_input()
    |> find_intersections_with_steps()
    |> Enum.map(fn {_pos, steps} -> steps end)
    |> Enum.min()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(&parse_wire/1)
  end

  def parse_wire(wire) do
    wire
    |> Enum.map(&parse_direction/1)
  end

  def parse_direction("U" <> length), do: [-String.to_integer(length), 0]
  def parse_direction("D" <> length), do: [String.to_integer(length), 0]
  def parse_direction("L" <> length), do: [0, -String.to_integer(length)]
  def parse_direction("R" <> length), do: [0, String.to_integer(length)]

  def wire_to_set(wire) do
    wire
    |> Enum.reduce({{0, 0}, MapSet.new()}, fn vector, {position, set} ->
      {new_position, new_set} = draw_line(position, vector)
      {new_position, MapSet.union(set, new_set)}
    end)
    |> elem(1)
  end

  def draw_line({r, c}, [dr, dc]) do
    row_step = if dr >= 0, do: 1, else: -1
    col_step = if dc >= 0, do: 1, else: -1

    wire_set =
      for row <- r..(r + dr)//row_step, col <- c..(c + dc)//col_step, reduce: MapSet.new() do
        set ->
          MapSet.put(set, {row, col})
      end

    {{r + dr, c + dc}, wire_set}
  end

  def find_intersection_points(wire1, wire2) do
    wire1_set = wire_to_set(wire1)
    wire2_set = wire_to_set(wire2)

    MapSet.intersection(wire1_set, wire2_set)
    |> MapSet.to_list()
  end

  def find_intersections([wire1, wire2]) do
    find_intersection_points(wire1, wire2)
    |> Enum.reject(fn {r, c} -> r == 0 and c == 0 end)
  end

  def wire_to_steps_map(wire) do
    wire
    |> Enum.reduce({{0, 0}, 0, %{}}, fn vector, {position, steps, map} ->
      {new_position, new_steps, new_map} = draw_line_with_steps(position, vector, steps, map)
      {new_position, new_steps, new_map}
    end)
    |> elem(2)
  end

  def draw_line_with_steps({r, c}, [dr, dc], current_steps, steps_map) do
    row_step = if dr >= 0, do: 1, else: -1
    col_step = if dc >= 0, do: 1, else: -1

    # Generate all positions in the line
    positions =
      for row <- r..(r + dr)//row_step, col <- c..(c + dc)//col_step do
        {row, col}
      end

    # Skip the starting position (it's where we already are)
    positions = if positions == [], do: [], else: tl(positions)

    # Add each position to the map with its step count (only if not already visited)
    {final_map, final_steps} =
      Enum.reduce(positions, {steps_map, current_steps}, fn pos, {map, step_count} ->
        new_step_count = step_count + 1

        new_map =
          if Map.has_key?(map, pos) do
            map
          else
            Map.put(map, pos, new_step_count)
          end

        {new_map, new_step_count}
      end)

    {{r + dr, c + dc}, final_steps, final_map}
  end

  def find_intersections_with_steps([wire1, wire2]) do
    wire1_steps = wire_to_steps_map(wire1)
    wire2_steps = wire_to_steps_map(wire2)

    # Find intersection positions
    wire1_positions = MapSet.new(Map.keys(wire1_steps))
    wire2_positions = MapSet.new(Map.keys(wire2_steps))

    MapSet.intersection(wire1_positions, wire2_positions)
    |> Enum.map(fn pos ->
      combined_steps = Map.get(wire1_steps, pos) + Map.get(wire2_steps, pos)
      {pos, combined_steps}
    end)
    |> Enum.reject(fn {{r, c}, _steps} -> r == 0 and c == 0 end)
  end
end
