# This Elixir script defines a module, Ui.Tetris.Points, that provides functions for manipulating Tetris block points.
# It includes operations for moving points to a new location, transposing, mirroring, flipping, rotating, and adding color to points.

defmodule Ui.Tetris.Points do

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

  # Mirror points horizontally.
  def mirror(points) do
    points
    |> Enum.map(fn {x, y} -> {5 - x, y} end)
  end

  # Conditionally mirror points based on a boolean value.
  def mirror(points, false), do: points
  def mirror(points, true), do: mirror(points)

  ##------------- Rotation --------------##

  # Rotate points 90 degrees clockwise.
  def rotate_90(points) do
    points
    |> transpose()
    |> mirror()
  end

  # Rotate points by a specified angle in degrees.
  def rotate(points, 0), do: points

  def rotate(points, degrees) do
    rotate(
      rotate_90(points),
      degrees - 90
    )
  end

  ##------------- To be clear --------------##

  # Explanation of point transformations with examples.

  #-- Color --#

  # Add color to points.
  def color(points, color) do
    Enum.map(points, fn point -> add_color(point, color) end)
  end

  defp add_color({_x, _y, _c} = point, _color), do: point
  defp add_color({x, y}, color), do: {x, y, color}

  #-- Show Terminal --#

  # Convert points to a string representation for printing in the terminal.
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

  # Print points to the terminal.
  def print(points) do
    IO.puts(__MODULE__.to_string(points))
    points
  end

end
