defmodule Ui.TetrisGiant.PointsGiant do

  #-- Move to an other location --#

  def move_to_location(points, {x, y} = _location) do
    Enum.map(points, fn {dx, dy} -> {dx + x, dy + y} end)
  end

  #-- Transpose --#

  def transpose(points) do
    points
    |> Enum.map(fn {x, y} -> {y, x} end)
  end

  #-- Mirror & Flip --#

  def mirror(points) do
    points
    |> Enum.map(fn {x, y} -> {5 - x, y} end)
  end

  def mirror(points, false), do: points
  def mirror(points, true), do: mirror(points)

  def flip(points) do
    points
    |> Enum.map(fn {x, y} -> {x, 5 - y} end)
  end

  ##------------- Rotation --------------##

  def rotate_90(points) do
    points
    |> transpose()
    |> mirror()
  end

  def rotate(points, 0), do: points

  def rotate(points, degrees) do
    rotate(
      rotate_90(points),
      degrees - 90
    )
  end

  ##------------- To be clear --------------##

  #    1 2 3
  #  1 X _ _
  #  2 X _ _
  #  3 X X _
  #
  #  --> transpose
  #
  #    1 2 3
  #  1 X X X
  #  2 _ _ X
  #  3 _ _ _
  #
  #  --> mirror
  #
  #    1 2 3
  #  1 X X X
  #  2 X _ _
  #  3 _ _ _
  #
  #  == rotate 90°

  #-- Color --#

  def color(points, color) do
    Enum.map(points, fn point -> add_color(point, color) end)
  end

  defp add_color({_x, _y, _c} = point, _color), do: point
  defp add_color({x, y}, color), do: {x, y, color}

  #-- Show Terminal --#

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

  def print(points) do
    IO.puts(__MODULE__.to_string(points))
    points
  end

end
