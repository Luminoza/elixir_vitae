defmodule Ui.Tetris.BottomTest do
  use ExUnit.Case

  import Ui.Tetris.Bottom

  # Test for collision detection
  test "Collision" do
    bottom = %{{1, 1} => {1, 1, :blue}}

    assert collides?(bottom, {1,1})
    refute collides?(bottom, {1,2})

    assert collides?(bottom, {1,1, :blue})
    assert collides?(bottom, {1,1, :red})
    refute collides?(bottom, {1,2, :red})

    assert collides?(bottom, [{1,2, :red}, {1,1, :red}])
    refute collides?(bottom, [{1,2, :orange}, {1,3, :red}])
  end

  # Test for merging blocks
  test "Merges" do
    bottom = %{{1, 1} => {1, 1, :blue}}

    actual = merge(bottom, [{1,2, :red}, {1,3, :red}])
    expected = %{
      {1, 1} => {1, 1, :blue},
      {1, 2} => {1, 2, :red},
      {1, 3} => {1, 3, :red}
    }

    assert actual == expected
  end

  # Test for identifying a complete row
  test "complete row" do
    bottom = new_bottom(20, [{{19, 19}, {19, 19, :red}}])

    assert complete_row(bottom) == [20]
  end

  # Test for collapsing a single row
  test "collapse single row" do
    bottom = new_bottom(20, [{{19, 19}, {19, 19, :red}}])
    actual = Map.keys(collapse_row(bottom, 20))
    refute {19, 19} in actual
    assert {19, 20} in actual
    assert Enum.count(actual) == 1
  end

  # Test for full collapse with a single row
  test "full collapse with single row" do
    bottom = new_bottom(20, [{{19, 19}, {19, 19, :red}}])
    {actual_count, actual_bottom} = full_collapse(bottom)

    assert actual_count == 1
    assert {19, 20} in Map.keys(actual_bottom)
  end

  # Helper function to create a new bottom with a complete row and additional blocks
  def new_bottom(complete_row, xtras) do
    (xtras ++
    (1..10
      |> Enum.map(fn x ->
        {{x, complete_row}, {x, complete_row, :red}}
      end)))
      |> Map.new
  end
end
