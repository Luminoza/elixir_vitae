# This Elixir script defines a module, Ui.TetrisGiant.BottomGiant, that provides functions for managing the bottom layer of Tetris
# in a "giant" version. It includes functions for merging points, checking collisions, detecting complete rows, collapsing them,
# and performing a full collapse of the bottom layer.

defmodule Ui.TetrisGiant.BottomGiant do

  ##------------- Add to bottom --------------##

  # Merge points into the bottom layer.
  def merge(bottom, points) do
    points
    |> Enum.map(fn {x, y, color} -> {{x, y}, {x, y, color}} end)
    |> Enum.into(bottom)
  end

  ##------------- Collisions --------------##

  # Check if a point or a list of points collides with the bottom layer.
  def collides?(bottom, {x, y, _color}), do: collides?(bottom, {x, y})

  def collides?(bottom, {x, y}) do
    !!Map.get(bottom, {x, y}) || y < 1 || y > 20 || x > 65
  end

  def collides?(bottom, points) when is_list(points) do
    Enum.any?(points, fn y -> collides?(bottom, y) end)
  end

  ##------------- Ligne complette --------------##

  #-- What is a row ? --#

  # Find and return complete rows in the bottom layer.
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
      |> Enum.filter(fn {x, _y} -> x == row end)
      |> Enum.count

    count == 20 # Adjust based on the size of the board
  end

  ##------------- Collapse A Complete Row --------------##

  # Collapse a complete row in the bottom layer.
  def collapse_row(bottom, row) do
    bad_keys =
      bottom
      |> Map.keys
      |> Enum.filter(fn {x, _y} -> x == row end)

    bottom
    |> Map.drop(bad_keys)
    |> Enum.map(&move_bad_point_up(&1, row))
    |> Map.new
  end

  # Move a point up when collapsing a row.
  def move_bad_point_up({{x, y}, {x, y, color}}, row) when x < row do
    {{x + 1, y}, {x + 1, y, color}}
  end

  # Don't move the point if it's not below the collapsed row.
  def move_bad_point_up(key_value, _row) do
    key_value
  end

  #-- Faire tomber toutes les lignes au dessus --#

  # Perform a full collapse of the bottom layer.
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
