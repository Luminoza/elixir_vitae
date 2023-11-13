# UiWeb.LedLive:
# This module defines a LiveView component for the LED Website, allowing dynamic updates
# and interactions. It handles mounting, event handling, and rendering of the LED control
# interface. Users can turn the LED on or off, adjust brightness, and navigate to other
# related pages. The brightness level is visually represented using a meter, and control
# buttons trigger corresponding events. Additionally, a link is provided to the Reverse LED
# page for additional functionality.

defmodule UiWeb.LedLive do
  # Use the UiWeb live view functionality
  use UiWeb, :live_view

  # Initial mount of the live view
  def mount(_params, _session, socket) do
    {:ok, assign(socket, brightness: 0)}
  end

  # Event handler for turning the LED on
  def handle_event("on", _, socket) do
    Ui.Manager.set_brightness(100)
    {:noreply, assign(socket, brightness: 100)}
  end

  # Event handler for increasing brightness
  def handle_event("up", _, socket) do
    new_brightness = min(socket.assigns.brightness + 10, 100)
    Ui.Manager.set_brightness(new_brightness)
    {:noreply, assign(socket, brightness: new_brightness)}
  end

  # Event handler for turning the LED off
  def handle_event("off", _, socket) do
    Ui.Manager.set_brightness(0)
    {:noreply, assign(socket, brightness: 0)}
  end

  # Event handler for decreasing brightness
  def handle_event("down", _, socket) do
    new_brightness = max(socket.assigns.brightness - 10, 0)
    Ui.Manager.set_brightness(new_brightness)
    {:noreply, assign(socket, brightness: new_brightness)}
  end

  # Rendering the live view
  def render(assigns) do
    ~H"""
    <head>
      <!-- Title of the LED Website -->
      <title>The LED Website · Antonin TERRASSON</title>
    </head>

    <main style="margin-top: 6%;" class="moitie-ecran">
      <!-- Title and link to the LED Website -->
      <h1 class="title">The LED Website<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">®</a></h1>

      <!-- Brightness meter and control buttons -->
      <div id="light" class="mt-20">
        <div class="meter">
          <span style={"width: #{@brightness}%"}>
            <%= @brightness %>%
          </span>
        </div>

        <!-- Buttons for turning on, off, increasing, and decreasing brightness -->
        <button class="action-button on" phx-click="on">
          <span>On</span>
        </button>

        <button class="action-button off" phx-click="off">
          <span>Off</span>
        </button>

        <button class="action-button up" phx-click="up">
          <span>Up</span>
        </button>

        <button class="action-button down" phx-click="down">
          <span>Down</span>
        </button>

        <!-- Link to the Reverse LED page -->
        <a href="/led/reverseled" class="action-button reverse">Reverse</a>
      </div>
    </main>
    """
  end
end
