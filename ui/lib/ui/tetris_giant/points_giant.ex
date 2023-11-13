# This Elixir script defines a module, Ui.TetrisGiant.PointsGiant, that provides functions for manipulating points in the "giant" version
# of Tetris. It includes functions for moving points to a new location, transposing, mirroring, flipping, rotating, adding color, and
# displaying points in the terminal.

defmodule Ui.TetrisGiant.PointsGiant do

  #-- Move to an other location --#

  # Move points to a new location.
  def move_to_location(points, {x, y} = _location) do
    Enum.map(points, fn {dx, dy} -> {dx + x, dy + y} end)
  end

  #-- Transpose --#

  # Transpose points (swap x and y coordinates).
  def transpose(points) do
    points
    |> Enum.map(fn {x, y} -> {y, x} end)
  end

  #-- Mirror & Flip --#

  # Mirror points along the y-axis.
  def mirror(points) do
    points
    |> Enum.map(fn {x, y} -> {5 - x, y} end)
  end

  # Don't mirror points if the condition is false.
  def mirror(points, false), do: points
  # Mirror points along the x-axis if the condition is true.
  def mirror(points, true), do: mirror(points)

  # Flip points along the x-axis.
  def flip(points) do
    points
    |> Enum.map(fn {x, y} -> {x, 5 - y} end)
  end

  ##------------- Rotation --------------##

  # Rotate points 90 degrees by transposing and mirroring.
  def rotate_90(points) do
    points
    |> transpose()
    |> mirror()
  end

  # Rotate points by the specified degrees.
  def rotate(points, 0), do: points

  def rotate(points, degrees) do
    rotate(
      rotate_90(points),
      degrees - 90
    )
  end

  ##------------- To be clear --------------##

  # Define a color for each point and display them in the terminal.
  def color(points, color) do
    Enum.map(points, fn point -> add_color(point, color) end)
  end

  # Add color information to a point.
  defp add_color({_x, _y, _c} = point, _color), do: point
  defp add_color({x, y}, color), do: {x, y, color}

  # Show points in the terminal with color.
  def to_string(points) do
    map =
      points
      |> Enum.map(fn key -> {key, "◼︎"} end)
      |> Map.new()

    for y <- (1..4), x <- (1..4) do
      Map.get(map, {x, y}, "◻︎")
    end
    |> Enum.chunk_every(4)
    |> Enum.map(&(Enum.join/1))
    |> Enum.join("\n")
  end

  # Print points in the terminal.
  def print(points) do
    IO.puts(__MODULE__.to_string(points))
    points
  end

end
