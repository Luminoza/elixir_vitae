# This Elixir script defines a module, Ui.TetrisGiant.TetrisGiant, that provides functions for managing the giant version of Tetris.
# It includes functions for preparing blocks, moving blocks down, handling collisions, attempting to move blocks, and calculating scores.

defmodule Ui.TetrisGiant.TetrisGiant do

  alias Ui.TetrisGiant.BlockGiant
  alias Ui.TetrisGiant.PointsGiant
  alias Ui.TetrisGiant.BottomGiant

  ##------------- Prearation du block --------------##

  ## Pour s'assurer que le block est créer à un endoit sans collision

  # Prepare a block by ensuring it is created in a location without collision.
  def prepare(block) do
    block
    |> BlockGiant.prepare
    |> PointsGiant.move_to_location(block.location)
  end

  ##------------- Move down a block --------------##

  ## si il y a une collision faire la gestion

  # Move a block down, handle collisions, and update the game state.
  def drop(block, bottom, color) do
    new_block =
      BlockGiant.down(block)

    if_drop(
      BottomGiant.collides?(bottom, prepare(new_block)),
      bottom,
      block,
      new_block,
      color
    )
  end

  ##-- Si collision --##

  # Handle collision when a block cannot be dropped further.
  def if_drop(true, bottom, old_block, _new_block, color) do

    new_block = BlockGiant.new_random()

    points =
      old_block
      |> prepare()
      |> PointsGiant.color(color)

    {count, new_bottom} =
      bottom
      |> BottomGiant.merge(points)
      |> BottomGiant.full_collapse

    %{
      block: new_block,
      bottom: new_bottom,
      score: score(count),
      game_over: BottomGiant.collides?(new_bottom, prepare(new_block))
    }
  end

  ##-- Si pas collision --##

  # Handle when a block can be dropped without collision.
  def if_drop(false, bottom, _old_block, new_block, _color) do
    %{
      block: new_block,
      bottom: bottom,
      score: 1,
      game_over: false
    }
  end

  ##------------- Try to move --------------##

  # Try to move a block left, right, or rotate it, and handle collisions.
  def try_left(block, bottom), do: try_move(block, bottom, &BlockGiant.left/1)
  def try_right(block, bottom), do: try_move(block, bottom, &BlockGiant.right/1)
  def try_rotate(block, bottom), do: try_move(block, bottom, &BlockGiant.rotate/1)

  def try_move(block, bottom, f) do
    new_block = f.(block)

    if BottomGiant.collides?(bottom, prepare(new_block)) do
      block
    else
      new_block
    end
  end

  ##------------- Calcul du score --------------##

  # Calculate the score based on the number of collapsed rows.
  def score(0), do: 0
  def score(count) do
    100 * round(:math.pow(2, count))
  end

end
