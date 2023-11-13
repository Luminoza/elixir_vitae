# This Elixir script defines a module, Ui.Tetris, that provides functions for preparing, moving, and scoring Tetris blocks.
# It includes operations for preparing a block, dropping it down, handling collisions, trying to move left, right, or rotate,
# and calculating the score based on completed rows.

defmodule Ui.Tetris do

  alias Ui.Tetris.Block
  alias Ui.Tetris.Points
  alias Ui.Tetris.Bottom

  ##------------- Preparation du block --------------##

  ## To ensure that the block is created at a location without collision

  # Prepare a block for placement, ensuring no collision.
  def prepare(block) do
    block
    |> Block.prepare
    |> Points.move_to_location(block.location)
  end

  ##------------- Move down a block --------------##

  ## If there is a collision, handle it

  # Drop a block down and handle collisions.
  def drop(block, bottom, color) do
    new_block =
      Block.down(block)

    if_drop(
      Bottom.collides?(bottom, prepare(new_block)),
      bottom,
      block,
      new_block,
      color
    )
  end

  ##-- If collision --##

  # Handle collision by merging points, collapsing rows, and updating the game state.
  def if_drop(true, bottom, old_block, _new_block, color) do

    new_block = Block.new_random()

    points =
      old_block
      |> prepare()
      |> Points.color(color)

    {count, new_bottom} =
      bottom
      |> Bottom.merge(points)
      |> Bottom.full_collapse

    %{
      block: new_block,
      bottom: new_bottom,
      score: score(count),
      game_over: Bottom.collides?(new_bottom, prepare(new_block))
    }
  end

  ##-- If no collision --##

  # If there is no collision, update the game state.
  def if_drop(false, bottom, _old_block, new_block, _color) do
    %{
      block: new_block,
      bottom: bottom,
      score: 1,
      game_over: false
    }
  end

  ##------------- Try to move --------------##

  # Try to move a block left, right, or rotate and handle collisions.
  def try_left(block, bottom), do: try_move(block, bottom, &Block.left/1)
  def try_right(block, bottom), do: try_move(block, bottom, &Block.right/1)
  def try_rotate(block, bottom), do: try_move(block, bottom, &Block.rotate/1)

  def try_move(block, bottom, f) do
    new_block = f.(block)

    if Bottom.collides?(bottom, prepare(new_block)) do
      block
    else
      new_block
    end
  end

  ##------------- Calculate score --------------##

  # Calculate the score based on the number of completed rows.
  def score(0), do: 0
  def score(count) do
    100 * round(:math.pow(2, count))
  end

end
