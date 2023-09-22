defmodule Ui.TetrisGiant.TetrisGiant do

  alias Ui.TetrisGiant.BlockGiant
  alias Ui.TetrisGiant.PointsGiant
  alias Ui.TetrisGiant.BottomGiant

  ##------------- Prearation du block --------------##

  ## Pour s'assurer que le block est créer à un endoit sans collision

  def prepare(block) do
    block
    |> BlockGiant.prepare
    |> PointsGiant.move_to_location(block.location)
  end

  ##------------- Move down a block --------------##

  ## si il y a une collision faire la gestion

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

  def if_drop(false, bottom, _old_block, new_block, _color) do
    %{
      block: new_block,
      bottom: bottom,
      score: 1,
      game_over: false
    }
  end

  ##------------- Calcul du score --------------##

  def score(0), do: 0
  def score(count) do
    100 * round(:math.pow(2, count))
  end

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

end
