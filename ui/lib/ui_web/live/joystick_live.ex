defmodule UiWeb.JoystickLive do
  use UiWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, x: 0.0, y: 0.0, angle: 0, speed: 0)}
  end

  def handle_info(%{x: x, y: y, angle: angle, speed: speed}, socket) do
    {:noreply, assign(socket, x: x, y: y, angle: angle, speed: speed)}
  end

  def handle_cast({:update_joystick, x, y, angle, speed}, socket) do
    {:noreply, assign(socket, x: x, y: y, angle: angle, speed: speed)}
  end

  def render(assigns) do
    ~L"""
    <head>
      <title>The Joystick Website · Antonin TERRASSON</title>
    </head>

    <main class="moitie-ecran" style="margin-top: 5%;">
      <h1 class="title">The Joystick Website<a href="https://www.youtube.com/watch?v=y6120QOlsfU&t=0m31s">®</a></h1>

      <div class="flex items-center justify-between font-semibold leading-6 text-zinc-900 mt-20 p-2 bg-gradient-to-b from-red-300 to-yellow-200 rounded-lg" style="margin-top: 20%;">
        <p>X: <%= @x %></p>
        <p>Y: <%= @y %></p>
        <p>Speed: <%= @speed %>%</p>
        <p>Angle: <%= @angle %></p>
      </div>
    </main>
    """
  end
end
