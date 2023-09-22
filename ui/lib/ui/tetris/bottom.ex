defmodule Ui.Tetris.Bottom do

  ##------------- Add to bottom --------------##

  def merge(bottom, points) do
    points
    |> Enum.map(fn {x, y, color} -> {{x, y}, {x, y, color}} end)
    |> Enum.into(bottom)
  end

  ##------------- Collisions --------------##

  def collides?(bottom, {x, y, _color}), do: collides?(bottom, {x, y})

  def collides?(bottom, {x, y}) do
    !!Map.get(bottom, {x, y}) || x < 1 || x > 10 || y > 20
  end

  def collides?(bottom, points) when is_list(points) do
    Enum.any?(points, fn x -> collides?(bottom, x) end)
  end

  ##------------- Ligne complette --------------##

  #-- What is a row ? --#

  def complete_row(bottom) do
    bottom
    |> Map.keys
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq
    |> Enum.filter(fn row -> complete?(bottom, row) end)
  end

  def complete?(bottom, row) do
    count =
      bottom
      |> Map.keys
      |> Enum.filter(fn {_x, y} -> y == row end)
      |> Enum.count

    count == 10 # En fonction de la taille du plateau
  end

    ##------------- Collapse A Complete Row --------------##

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

  #--  --#

  def move_bad_point_up({{x, y}, {x, y, color}}, row) when y < row do
    {{x, y + 1}, {x, y + 1, color}}
  end
  def move_bad_point_up(key_value, _row) do
    key_value
  end

  #-- Faire tomber toutes les lignes au dessus --#

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
