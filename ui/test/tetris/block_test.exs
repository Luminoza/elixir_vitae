defmodule Ui.Tetris.BlockTest do
  use ExUnit.Case

  import Ui.Tetris.Block
  alias Ui.Tetris.Points

  # Test to ensure a new block is created with the default name :i
  test "Creates a new block" do
    assert new_block().name == :i
  end

  # Test to ensure a new random block has valid attributes
  test "Create a new random block" do
    actual = new_random()
    assert actual.name in [:i, :l, :o,  :z, :t, :s]
    assert actual.rotation in [0, 90, 180, 270]
    assert actual.reflection in [true, false]
  end

  # Test to check if block movements (right, down, left, rotate) produce the expected result
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

  # Test to verify the correctness of block shapes
  test "Does the shaps are correct" do

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

  # test "Does the block miror and flip" do
  #   mirrored = Points.mirror([{1, 1}])
  #   assert mirrored == [{4, 1}]

  #   flipped = Points.flip(mirrored)
  #   assert flipped == [{4, 4}]

  #   rotated_90 = Points.rotate_90(flipped)
  #   assert rotated_90 == [{1, 4}]

  #   rotated_180 = Points.rotate_90(rotated_90)
  #   assert rotated_180 == [{1, 1}]
  # end

  # Test to check if a block can be converted to a string representation
  test "Can I convert a block in string" do
    actual = new_block() |> Ui.Tetris.Block.to_string()
    expected = "◻︎◼︎◻︎◻︎\n◻︎◼︎◻︎◻︎\n◻︎◼︎◻︎◻︎\n◻︎◼︎◻︎◻︎"

    assert actual == expected
  end

  # test "inspect block" do
  #   _actual = new_block() |> inspect
  #   expected =
  #     """
  #     ◻︎◼︎◻︎◻︎
  #     ◻︎◼︎◻︎◻︎
  #     ◻︎◼︎◻︎◻︎
  #     ◻︎◼︎◻︎◻︎
  #     Location : {#{x_center()}, 0}, Reflection : false, Rotation : 0°.
  #     """
  #     assert _actual = expected
  # end

  #-- Fonctions --#

  # Function to create a new block with optional attributes
  def new_block(attributes \\ []) do
    new(attributes)
  end

  # Function to assert a single point in a list of points
  def assert_point([actual], expected) do
    assert actual == expected
    [actual]
  end

end
