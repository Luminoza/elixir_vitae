# This Elixir script defines a module, Ui.TetrisGiant.BlockGiant, that provides functions for creating and manipulating Tetris blocks
# in a "giant" version. It includes functions for creating blocks, moving them, rotating, and preparing them for rendering.

defmodule Ui.TetrisGiant.BlockGiant do

  alias Ui.TetrisGiant.PointsGiant

  ##------------- Default --------------##

  defstruct [
    name: :i,
    location: {0, 800},
    rotation: 0,
    reflection: false
  ]

  ##------------- Create New --------------##

  # Create a new block with optional attributes.
  def new(attributes \\ []) do
    __struct__(attributes)
  end

  # Create a new random block with default attributes.
  def new_random() do
    %__MODULE__{
      name: random_name(),
      location: {-3, 8},
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

  # Generate a random rotation value from [0, 90, 180, 270].
  def random_rotation() do
    [0, 90, 180, 270]
    |> Enum.random
  end

  # Generate a random reflection value from [true, false].
  def random_reflection() do
    [true, false]
    |> Enum.random
  end

  ##------------- Movement --------------##

  #-- Down --#

  # Move the block down.
  def down(block) do
    %{block | location: point_down(block.location)}
  end

  # Calculate the new location when moving down.
  def point_down({x, y}) do
    {x + 1, y}
  end

  #-- Right --#

  # Move the block right.
  def right(block) do
    %{block | location: point_right(block.location)}
  end

  # Calculate the new location when moving right.
  def point_right({x, y}) do
    {x, y - 1}
  end

  #-- Left --#

  # Move the block left.
  def left(block) do
    %{block | location: point_left(block.location)}
  end

  # Calculate the new location when moving left.
  def point_left({x, y}) do
    {x, y + 1}
  end

  #------------- Rotation --------------#

  # Rotate the block.
  def rotate(block) do
    %{block | rotation: rotate_90(block.rotation)}
  end

  # Rotate 90 degrees.
  def rotate_90(degrees) do
    degrees + 90
  end

  #------------- Shape --------------#

  # Define shapes for different block names.

  def shape(%{name: :o}) do
    [
      {2, 2}, {3, 2},
      {2, 3}, {3, 3}
    ]
  end

  def shape(%{name: :i}) do
    [
      {2, 1},
      {2, 2},
      {2, 3},
      {2, 4}
    ]
  end

  def shape(%{name: :s}) do
    [
      {2, 1},
      {2, 2}, {3, 2},
             {3, 3}
    ]
  end

  def shape(%{name: :z}) do
    [
             {3, 1},
      {2, 2}, {3, 2},
      {2, 3}
    ]
  end

  def shape(%{name: :l}) do
    [
      {2, 1},
      {2, 2},
      {2, 3}, {3, 3}
    ]
  end

  def shape(%{name: :j}) do
    [
             {3, 1},
             {3, 2},
      {2, 3}, {3, 3}
    ]
  end

  def shape(%{name: :t}) do
    [
      {2, 1},
      {2, 2}, {3, 2},
      {2, 3}
    ]
  end

  #-- Color --#

  # Define colors based on block names.
  defp color(%{name: :o}), do: :yellow
  defp color(%{name: :i}), do: :blue
  defp color(%{name: :s}), do: :red
  defp color(%{name: :z}), do: :green
  defp color(%{name: :l}), do: :orange
  defp color(%{name: :j}), do: :pink
  defp color(%{name: :t}), do: :purple

  #-- String & Print --#

  # Prepare the block for rendering.
  def prepare(block) do
    block
    |> shape()
    |> PointsGiant.rotate(block.rotation)
    |> PointsGiant.mirror(block.reflection)
  end

  ##------------- To show in console --------------##

  # Convert the block to a string for console display.
  def to_string(block) do
    block
    |> prepare()
    |> PointsGiant.to_string()
  end

  # Print the block to the console.
  def print(block) do
    block
    |> prepare()
    |> PointsGiant.print()
    block
  end

  # Render the block with color and location.
  def render(block) do
    block
    |> prepare
    |> PointsGiant.move_to_location(block.location)
    |> PointsGiant.color(color block)
  end

  #-- Inspect --#

  # Implement the Inspect protocol for easy debugging.
  defimpl Inspect, for: Ui.TetrisGiant.BlockGiant do
    import Inspect.Algebra

    def inspect(block, _opts) do
      concat([
        Ui.TetrisGiant.BlockGiant.to_string(block),
        "\n",
        "Location : ",inspect(block.location),
        ", Reflection : ",inspect(block.reflection),
        ", Rotation : ",inspect(block.rotation), "°."
        ])
    end
  end

end
