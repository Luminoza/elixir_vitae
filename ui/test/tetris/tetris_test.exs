defmodule Ui.Tetris.TetrisTest do
  use ExUnit.Case

  import Ui.Tetris
  alias Ui.Tetris.Block

  # Test for trying to move right successfully
  test "try to move right, success" do
    block = Block.new(location: {5, 1})
    bottom = %{}

    expected = block |> Block.right
    actual = try_right(block, bottom)

    assert actual == expected
  end

  # Test for trying to move right, failure and return to the previous block
  test "try to move right, failure and return to the previous block" do
    block = Block.new(location: {8, 1})
    bottom = %{}

    expected = block
    actual = try_right(block, bottom)

    assert actual == expected
  end

  # Test for dropping without merging
  test "drop, no merging" do
    # block = Block.new(location: {5, 5})
    # bottom = %{}

    # expected =
    #   %{
    #     block: Block.down(block),
    #     bottom: %{},
    #     score: 1,
    #     game_over: false
    # }

    # actual = drop(block, bottom, :red)

    # assert actual = expected
  end

  # Test for dropping with merging
  test "drop and merging" do
    block = Block.new(location: {5, 16})
    bottom = %{}

    %{score: score, bottom: bottom} =
      drop(block, bottom, :red)

    assert Map.get(bottom, {7, 20}) == {7, 20, :red}
    assert score == 0
  end

  # Test for dropping to the bottom
  test "drop to bottom" do
    block = Block.new(location: {5, 16})
    bottom =
      for x <- 1..10, y <- 17..20, x != 7 do
        {{x, y}, {x, y, :red}}
      end
      |> Map.new

      %{score: score, bottom: bottom} =
        drop(block, bottom, :red)

    assert bottom == %{}
    assert score == 1600
  end

end
