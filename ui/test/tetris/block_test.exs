defmodule Ui.Tetris.BlockTest do
  use ExUnit.Case

  import Ui.Tetris.Block
  alias Ui.Tetris.Points

  test "Creates a new block" do
    assert new_block().name == :i
  end

  test "Create a new random block" do
    actual = new_random()
    assert actual.name in [:i, :l, :o,  :z, :t]
    assert actual.rotation in [0, 90, 180, 270]
    assert actual.reflection in [true, false]
  end

  test "Does the block moves" do
    actual =
      new_block()
      |> right
      |> down
      |> right
      |> left
      |> rotate

    assert actual.location == {41, 1}
    assert actual.rotation == 90
  end

  test "Does the shaps are good" do

    shape =
      new_block(name: :i)
      |> shape()

    assert {2, 2} in shape
  end

  test "Does translation works" do
    actual_points =
      new_block()
        |> shape()
        |> Points.move_to_location({1, 1})
        |> Points.move_to_location({0, 1})

    assert actual_points == [{3, 3}, {3, 4}, {3, 5}, {3, 6}]
  end

  test "Does the block miror and flip" do
    mirrored = Points.mirror([{1, 1}])
    assert mirrored == [{4, 1}]

    flipped = Points.flip(mirrored)
    assert flipped == [{4, 4}]

    rotated_90 = Points.rotate_90(flipped)
    assert rotated_90 == [{1, 4}]

    rotated_180 = Points.rotate_90(rotated_90)
    assert rotated_180 == [{1, 1}]
  end


  test "Can I convert a block in string" do
    actual = new_block() |> Ui.Tetris.Block.to_string()
    expected = "◻︎◼︎◻︎◻︎\n◻︎◼︎◻︎◻︎\n◻︎◼︎◻︎◻︎\n◻︎◼︎◻︎◻︎"

    assert actual == expected
  end

  test "inspect block" do
    _actual = new_block() |> inspect
    expected =
      """
      ◻︎◼︎◻︎◻︎
      ◻︎◼︎◻︎◻︎
      ◻︎◼︎◻︎◻︎
      ◻︎◼︎◻︎◻︎
      Location : {#{x_center()}, 0}, Reflection : false, Rotation : 0°.
      """
      assert _actual = expected
  end

  #-- Fonctions --#

  def new_block(attributes \\ []) do
    new(attributes)
  end

  def assert_point([actual], expected) do
    assert actual == expected
    [actual]
  end

end
