defmodule Aoc.Day06 do
  def part1(args) do
    args
    |> parse_input()
    |> count_orbits("COM", 0)
  end

  def part2(args) do
    orbit_map = parse_input(args)

    # Build bidirectional graph (can move up or down)
    graph = build_graph(orbit_map)

    # Find what YOU and SAN orbit
    you_parent = find_parent(orbit_map, "YOU")
    san_parent = find_parent(orbit_map, "SAN")

    # BFS to find shortest path
    bfs(graph, you_parent, san_parent)
  end

  defp build_graph(orbit_map) do
    # For each center -> satellites relationship, create bidirectional edges
    Enum.reduce(orbit_map, %{}, fn {center, satellites}, acc ->
      # Add center -> satellites edges
      acc = Map.put(acc, center, satellites ++ Map.get(acc, center, []))

      # Add satellites -> center edges (reverse direction)
      Enum.reduce(satellites, acc, fn satellite, acc2 ->
        Map.update(acc2, satellite, [center], &[center | &1])
      end)
    end)
  end

  defp find_parent(orbit_map, node) do
    orbit_map
    |> Enum.find_value(fn {center, satellites} ->
      if node in satellites, do: center, else: nil
    end)
  end

  defp bfs(graph, start, goal) do
    queue = :queue.from_list([{start, 0}])
    visited = MapSet.new([start])
    do_bfs(graph, queue, goal, visited)
  end

  defp do_bfs(graph, queue, goal, visited) do
    case :queue.out(queue) do
      {{:value, {current, distance}}, new_queue} ->
        if current == goal do
          distance
        else
          neighbors = Map.get(graph, current, [])

          {new_queue, new_visited} =
            Enum.reduce(neighbors, {new_queue, visited}, fn neighbor, {q, v} ->
              if MapSet.member?(v, neighbor) do
                {q, v}
              else
                {:queue.in({neighbor, distance + 1}, q), MapSet.put(v, neighbor)}
              end
            end)

          do_bfs(graph, new_queue, goal, new_visited)
        end

      {:empty, _} ->
        nil
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ")"))
    |> Enum.reduce(%{}, fn [center, satellite], acc ->
      Map.update(acc, center, [satellite], &[satellite | &1])
    end)
  end

  def count_orbits(map, planet, depth) do
    satellites = Map.get(map, planet, [])

    depth +
      Enum.reduce(satellites, 0, fn satellite, acc ->
        acc + count_orbits(map, satellite, depth + 1)
      end)
  end
end
