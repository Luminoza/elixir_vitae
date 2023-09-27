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

  def new(attributes \\ []) do
    __struct__(attributes)
  end

  def new_random() do
    %__MODULE__{
      name: random_name(),
      location: {-3, 8},
      rotation: random_rotation(),
      reflection: random_reflection()
    }
  end

  #-- Name --#

  def random_name() do
    ~w(o i s z l j t)a
    |> Enum.random
  end

  #-- Rotation --#

  def random_rotation() do
    [0, 90, 180, 270]
    |> Enum.random
  end

  def random_reflection() do
    [true, false]
    |> Enum.random
  end

  ##------------- Mouvment --------------##

  #-- Down --#

  def down(block) do
    %{block | location: point_down(block.location)}
  end

  def point_down({x, y}) do
    {x + 1, y}
  end

  #-- Right --#

  def right(block) do
    %{block | location: point_right(block.location)}
  end

  def point_right({x, y}) do
    {x, y - 1}
  end

  #-- Left --#

  def left(block) do
    %{block | location: point_left(block.location)}
  end

  def point_left({x, y}) do
    {x, y + 1}
  end

  #------------- Rotation --------------#

  def rotate(block) do
    %{block | rotation: rotate_90(block.rotation)}
  end

  def rotate_90(degrees) do
    degrees + 90
  end

  #------------- Shape --------------#

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

  defp color(%{name: :o}), do: :yellow
  defp color(%{name: :i}), do: :blue
  defp color(%{name: :s}), do: :red
  defp color(%{name: :z}), do: :green
  defp color(%{name: :l}), do: :orange
  defp color(%{name: :j}), do: :pink
  defp color(%{name: :t}), do: :purple

  #-- String & Print --#

  def prepare(block) do
    block
    |> shape()
    |> PointsGiant.rotate(block.rotation)
    |> PointsGiant.mirror(block.reflection)
  end

  ##------------- To show in console --------------##

  def to_string(block) do
    block
    |> prepare()
    |> PointsGiant.to_string()
  end

  def print(block) do
    block
    |> prepare()
    |> PointsGiant.print()
    block
  end

  def render(block) do
    block
    |> prepare
    |> PointsGiant.move_to_location(block.location)
    |> PointsGiant.color(color block)
  end

  #-- Inspect --#

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
