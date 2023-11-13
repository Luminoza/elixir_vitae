# This Elixir script defines a module, Ui.Tetris.Bottom, that handles operations related to the bottom layer of Tetris.
# It includes functions for merging points to the bottom, checking collisions, identifying complete rows,
# collapsing complete rows, and performing a full collapse of the bottom layer.

defmodule Ui.Tetris.Bottom do

  ##------------- Add to bottom --------------##

  # Merge points to the bottom layer.
  def merge(bottom, points) do
    points
    |> Enum.map(fn {x, y, color} -> {{x, y}, {x, y, color}} end)
    |> Enum.into(bottom)
  end

  ##------------- Collisions --------------##

  # Check if a point collides with the bottom layer.
  def collides?(bottom, {x, y, _color}), do: collides?(bottom, {x, y})

  def collides?(bottom, {x, y}) do
    !!Map.get(bottom, {x, y}) || x < 1 || x > 10 || y > 20
  end

  # Check if a list of points collides with the bottom layer.
  def collides?(bottom, points) when is_list(points) do
    Enum.any?(points, fn x -> collides?(bottom, x) end)
  end

  ##------------- Complete Row --------------##

  # Identify complete rows in the bottom layer.
  def complete_row(bottom) do
    bottom
    |> Map.keys
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq
    |> Enum.filter(fn row -> complete?(bottom, row) end)
  end

  # Check if a row is complete in the bottom layer.
  def complete?(bottom, row) do
    count =
      bottom
      |> Map.keys
      |> Enum.filter(fn {_x, y} -> y == row end)
      |> Enum.count

    count == 10 # Adjust based on the size of the game board
  end

  ##------------- Collapse A Complete Row --------------##

  # Collapse a complete row in the bottom layer.
  def collapse_row(bottom, row) do
    bad_keys =
      bottom
      |> Map.keys
      |> Enum.filter(fn {_x, y} -> y == row end)

    bottom
    |> Map.drop(bad_keys)
    |> Enum.map(&move_bad_point_up(&1, row))
    |> Map.new
  end

  # Move a point up if it is below the collapsed row.
  def move_bad_point_up({{x, y}, {x, y, color}}, row) when y < row do
    {{x, y + 1}, {x, y + 1, color}}
  end
  def move_bad_point_up(key_value, _row) do
    key_value
  end

  ##------------- Full Collapse --------------##

  # Perform a full collapse of the bottom layer, collapsing all complete rows.
  def full_collapse(bottom) do
    rows =
      bottom
      |> complete_row
      |> Enum.sort

    new_bottom =
      Enum.reduce(rows, bottom, &collapse_row(&2, &1))

    {Enum.count(rows), new_bottom}
  end

end
