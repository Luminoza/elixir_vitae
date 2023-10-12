defmodule UiWeb.TetrisLive do
  use UiWeb, :live_view

  alias Ui.Tetris
  alias Ui.Tetris.Block
  alias Ui.Tetris.Points

  @box_width 20
  @box_height 20

  def mount(_params, _session, socket) do
    :timer.send_interval 200, self(), :tick # La vitesse de jeux

    Phoenix.PubSub.subscribe(Ui.PubSub, "update_right_state")
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_left_state")
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_gravity_state")
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_turn_state")

    {:ok, start_game(socket)}
  end

  ##------------- Render --------------##

  #-- Starting --#

  def render(%{state: :starting} = assigns) do
    ~L"""
      <head>
          <title>The Tetris Website · Antonin TERRASSON</title>
      </head>

      <main class="moitie-ecran-tetris">
        <h1 class="title">The Tetris Website<a href="https://www.youtube.com/watch?v=kIDWgqDBNXA&t=0m47s">®</a></h1>

        <div class="p-2 bg-gradient-to-b from-red-300 to-yellow-200 rounded-lg" phx-window-keydown="keydown">
          <%= raw svg_head()%>
          <%= raw svg_foot()%>
        </div>

        <button class="action-button play" phx-click="start">Play</button>

        <div class="mt-7">
          <a href="/tetris/giant" class="action-button giant">Giant</a>
        </div>
      </main>
    """
  end

  #-- Playing --#

  def render(%{state: :playing} = assigns) do
    ~L"""
      <head>
        <title>The Tetris Website · Antonin TERRASSON</title>
      </head>

      <main class="moitie-ecran-tetris">
      <h1 class="title">The Tetris Website<a href="https://www.youtube.com/watch?v=kIDWgqDBNXA&t=0m47s">®</a></h1>

      <button class="action-button right" phx-click="right-clic">Right</button>
      <button class="action-button left" phx-click="left-clic">Left</button>
      <button class="action-button turn" phx-click="turn-clic">Turn</button>
      <button class="action-button gravity" phx-click="down-clic">Gravity</button>


      <div class="p-2 bg-gradient-to-b from-red-300 to-yellow-200 rounded-lg" phx-window-keydown="keydown">
        <%= raw svg_head()%>

        <%= raw boxes(@piece) %>
        <%= raw boxes(Map.values(@bottom)) %>

        <%= raw svg_foot()%>
      </div>

      <a class="score">Your score is: <%= @score %></a>

      <div class="mt-7">
        <a href="/tetris/giant" class="action-button giant">Giant</a>
        <button class="action-button give_up" phx-click="give_up">Give Up</button>
      </div>
      </main>
    """
  end

  #-- Game Over --#

  def render(%{state: :game_over} = assigns) do
    ~L"""
      <head>
        <title>The Tetris Website · Antonin TERRASSON</title>
      </head>

      <main class="moitie-ecran-tetris">
        <h1 class="title">The Tetris Website<a href="https://www.youtube.com/watch?v=kIDWgqDBNXA&t=0m47s">®</a></h1>

        <div class="p-2 bg-gradient-to-b from-red-300 to-yellow-200 rounded-lg" phx-window-keydown="keydown">
          <%= raw svg_head()%>
          <%= raw svg_foot()%>
        </div>

        <h1 class="game_over"> Game Over </h1>
        <h2 class="score">Your score: <%= @score %></h2>

        <button class="action-button play_again" phx-click="start">Play again ?</button>

        <div class="mt-7">
          <a href="/tetris/giant" class="action-button giant">Giant</a>
        </div>
      </main>
    """
  end

  ##------------- Game --------------##

  #-- Start --#

  defp start_game(socket) do
    assign(socket,
      state: :starting,
      box_width: 20,
      box_height: 20
    )
  end

  #-- New --#

  def new_game(socket) do
    assign(socket,
      state: :playing,
      score: 0,
      bottom: %{}
    )
    |> new_block
    |> show_piece
  end

  #-- Create Block --#

  def new_block(socket) do
    block =
      Block.new_random()
      |> Map.put(:location, {3, -3})

    assign(socket, block: block)
  end

   #-- Show Piece --#

  def show_piece(socket) do
    block = socket.assigns.block

    points =
      block
      |> Block.prepare
      |> Points.move_to_location(block.location)
      |> Points.color(color(block))

    assign(socket, piece: points)
  end

  ##------------- SVG --------------##

  def svg_head() do
    """
    <svg
      style="background-color: #F8F8F8"
      width="200" height="400"
      xml:space="preserve">
    """
  end

  def svg_foot(), do: "</svg>"

  ##------------- Boxes --------------##

  def boxes(points_with_colors) do
    points_with_colors
    |> Enum.map(fn {x, y, color} ->
      box({x, y}, color)
    end)
    |> Enum.join("\n")

  end

  def box(point, color) do
    """
    #{square(point, shades(color).light)}
    #{triangle(point, shades(color).dark)}
    """
  end

  #-- Forme --#

  def square(point, shade) do
    {x, y} = to_pixels(point, 20, 20)
    """
    <rect
      x = "#{x + 1}"
      y = "#{y + 1}"
      style="fill:##{shade};"
      width = "#{@box_width - 2}"
      height ="#{@box_height - 1}"
    />
    """
  end

  def triangle(point, shade) do
    {x, y} = to_pixels(point, 20, 20)
    """
    <polyline
      style="fill:##{shade};"
      points="#{x + 1}, #{y + 1} #{x + @box_width}, #{y + 1} #{x + @box_width}, #{y + @box_height}"
    />
    """
  end

  defp to_pixels({x, y}, box_width, box_height), do: {(x-1) * box_width, (y-1) * box_height}

  ##------------- Color --------------##

  defp shades(:yellow), do: %{light: "FDFD96", dark: "FDFD79"}
  defp shades(:blue), do: %{light: "A6C8E2", dark: "A6B4C8"}
  defp shades(:red), do: %{light: "FF8B8B", dark: "FF7878"}
  defp shades(:green), do: %{light: "9AFF9A", dark: "8FCF8F"}
  defp shades(:orange), do: %{light: "FFC68C", dark: "FFB15A"}
  defp shades(:pink), do: %{light: "FFC0CB", dark: "FFA4B2"}
  defp shades(:purple), do: %{light: "C0A1D9", dark: "B58DC1"}

  defp color(%{name: :o}), do: :yellow
  defp color(%{name: :i}), do: :blue
  defp color(%{name: :s}), do: :red
  defp color(%{name: :z}), do: :green
  defp color(%{name: :l}), do: :orange
  defp color(%{name: :j}), do: :pink
  defp color(%{name: :t}), do: :purple

  ##------------- Move --------------##

  def move(direction, socket) do
    socket
    |> do_move(direction)
    |> show_piece()
  end

  def drop(:playing, socket, fast) do

    old_block = socket.assigns.block

    response =
      Tetris.drop(
        old_block,
        socket.assigns.bottom,
        color(old_block)
      )

    bonus = if fast, do: 2, else: 0

    socket
    |> assign(
      block: response.block,
      bottom: response.bottom,
      score: socket.assigns.score + response.score + bonus,
      state: (if response.game_over, do: :game_over, else: :playing)
      )
    |> show_piece()
  end

  def drop(_not_playing, socket, _fast), do: socket

  def rotate(direction, socket) do
    socket
    |> do_rotate(direction)
    |> show_piece()
  end

  #-- do --#

  def do_move(socket, :left) do
    assign(socket, block: socket.assigns.block |> Tetris.try_left(socket.assigns.bottom))
  end

  def do_move(socket, :right) do
    assign(socket, block: socket.assigns.block |> Tetris.try_right(socket.assigns.bottom))
  end

  def do_drop(socket) do
    assign(socket, block: socket.assigns.block |> Block.down)
  end

  def do_rotate(socket, :rotate) do
    assign(socket, block: socket.assigns.block |> Tetris.try_rotate(socket.assigns.bottom))
  end

  ##------------- Handle --------------##

  #-- Move --#

  #- right -#

  def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
    {:noreply, move(:right, socket)}
  end
  def handle_event("right-clic", _, socket) do
    {:noreply, move(:right, socket)}
  end

  #- left -#

  def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, move(:left, socket)}
  end
  def handle_event("left-clic", _, socket) do
    {:noreply, move(:left, socket)}
  end

  #- down -#

  def handle_event("keydown", %{"key" => "ArrowDown"}, socket) do
    {:noreply, drop(socket.assigns.state, socket, :true)}
  end
  def handle_event("down-clic", _, socket) do
    {:noreply, drop(socket.assigns.state, socket, :true)}
  end

  #- turn -#

  def handle_event("keydown", %{"key" => "ArrowUp"}, socket) do
    {:noreply, rotate(:rotate, socket)}
  end
  def handle_event("turn-clic", _, socket) do
    {:noreply, rotate(:rotate, socket)}
  end

  #-- Others --#

  def handle_event("keydown", _, socket), do: {:noreply, socket}
  def handle_event("start", _, socket) do
    {:noreply, new_game(socket)}
  end

  def handle_event("give_up", _, socket) do
    {:noreply, assign(socket, state: :game_over)}
  end

  #-- Gravity --#

  def handle_info(:tick, socket) do
    {:noreply, drop(socket.assigns.state, socket, false)}
  end

  #-- Move Button physiques --#

  def handle_info(:update_right_state, socket) do
    {:noreply, move(:right, socket)}
  end
  def handle_info(:update_left_state, socket) do
    {:noreply, move(:left, socket)}
  end
  def handle_info(:update_gravity_state, socket) do
    {:noreply, drop(socket.assigns.state, socket, :true)}
  end
  def handle_info(:update_turn_state, socket) do
    {:noreply, rotate(:rotate, socket)}
  end

end
