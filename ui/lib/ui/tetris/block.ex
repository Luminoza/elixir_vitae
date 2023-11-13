# This Elixir script defines a module, Ui.Tetris.Block, that represents Tetris blocks.
# The module includes functions for creating new blocks, defining block movements, rotations, shapes, colors,
# and rendering blocks for display. It also provides functions for printing, converting to a string,
# and inspecting the block's attributes.

defmodule Ui.Tetris.Block do

  alias Ui.Tetris.Points

  ##------------- Default --------------##

  # Define the default attributes for a Tetris block.
  defstruct [
    name: :i,
    location: {40, 0},
    rotation: 0,
    reflection: false
  ]

  ##------------- Create New --------------##

  # Create a new block with the given attributes.
  def new(attributes \\ []) do
    __struct__(attributes)
  end

  # Create a new block with random attributes.
  def new_random() do
    %__MODULE__{
      name: random_name(),
      location: {3, -4},
      rotation: random_rotation(),
      reflection: random_reflection()
    }
  end

  #-- Name --#

  # Generate a random block name.
  def random_name() do
    ~w(o i s z l j t)a
    |> Enum.random

  end

  #-- Rotation --#

  # Generate a random rotation for a block.
  def random_rotation() do
    [0, 90, 180, 270]
    |> Enum.random
  end

  # Generate a random reflection for a block.
  def random_reflection() do
    [true, false]
    |> Enum.random
  end

  ##------------- Mouvment --------------##

  #-- Down --#

  # Move the block down by one unit.
  def down(block) do
    %{block | location: point_down(block.location)}
  end

  # Calculate the new point when moving down.
  def point_down({x, y}) do
    {x, y + 1}
  end

  #-- Right --#

  # Move the block to the right by one unit.
  def right(block) do
    %{block | location: point_right(block.location)}
  end

  # Calculate the new point when moving to the right.
  def point_right({x, y}) do
    {x + 1, y}
  end

  #-- Left --#

  # Move the block to the left by one unit.
  def left(block) do
    %{block | location: point_left(block.location)}
  end

  # Calculate the new point when moving to the left.
  def point_left({x, y}) do
    {x - 1, y}
  end

  #------------- Rotation --------------#

  # Rotate the block by 90 degrees.
  def rotate(block) do
    %{block | rotation: rotate_90(block.rotation)}
  end

  # Calculate the new rotation angle when rotating by 90 degrees.
  def rotate_90(degrees) do
    degrees + 90
  end

  #------------- Shape --------------#

  # Define the shape of the block based on its name.

  def shape(%{name: :o}) do
    [
      {2,2}, {3,2},
      {2,3}, {3,3}
    ]
  end

  def shape(%{name: :i}) do
    [
      {2,1},
      {2,2},
      {2,3},
      {2,4}
    ]
  end

  def shape(%{name: :s}) do
    [
      {2,1},
      {2,2}, {3,2},
             {3,3}
    ]
  end

  def shape(%{name: :z}) do
    [
             {3,1},
      {2,2}, {3,2},
      {2,3}
    ]
  end

  def shape(%{name: :l}) do
    [
      {2,1},
      {2,2},
      {2,3}, {3,3}
    ]
  end

  def shape(%{name: :j}) do
    [
             {3,1},
             {3,2},
      {2,3}, {3,3}
    ]
  end

  def shape(%{name: :t}) do
    [
      {2,1},
      {2,2}, {3,2},
      {2,3}
    ]
  end

  #-- Color --#

  # Determine the color of the block based on its name.

  defp color(%{name: :o}), do: :yellow
  defp color(%{name: :i}), do: :blue
  defp color(%{name: :s}), do: :red
  defp color(%{name: :z}), do: :green
  defp color(%{name: :l}), do: :orange
  defp color(%{name: :j}), do: :pink
  defp color(%{name: :t}), do: :purple

  #-- String & Print --#

  # Prepare the block for display by transforming its shape.
  def prepare(block) do
    block
    |> shape()
    |> Points.rotate(block.rotation)
    |> Points.mirror(block.reflection)
  end

  ##------------- To show in console --------------##

  # Convert the block to a string for display.
  def to_string(block) do
    block
    |> prepare()
    |> Points.to_string()
  end

  # Print the block and return it.
  def print(block) do
    block
    |> prepare()
    |> Points.print()
    block
  end

  # Render the block for display, applying color and position.
  def render(block) do
    block
    |> prepare
    |> Points.move_to_location(block.location)
    |> Points.color(color block)
  end

  #-- Inspect --#

  # Implement the Inspect protocol for the Block struct for easy inspection.
  defimpl Inspect, for: Ui.Tetris.Block do
    import Inspect.Algebra

    def inspect(block, _opts) do
      concat([
        Ui.Tetris.Block.to_string(block),
        "\n",
        "Location : ",inspect(block.location),
        ", Reflection : ",inspect(block.reflection),
        ", Rotation : ",inspect(block.rotation), "°."
        ])
    end
  end

end
