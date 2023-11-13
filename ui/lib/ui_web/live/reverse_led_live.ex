# UiWeb.ReverseLedLive:
# This module defines a LiveView component for the Reverse LED Website. It subscribes to
# a Phoenix PubSub channel to receive real-time updates on the LED state. The LED state
# is represented by a visual indicator on the web page. Users can navigate back to the
# main LED control page using the provided "Reverse" button. The LED state is updated
# dynamically based on external events, allowing for a responsive user interface.

defmodule UiWeb.ReverseLedLive do
  # Use the UiWeb live view functionality
  use UiWeb, :live_view

  # Initial mount of the live view
  def mount(_params, _session, socket) do
    # Subscribe to PubSub channel for LED state updates
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_led_state")
    {:ok, assign(socket, led_state: "led-off")}
  end

  # Event handler for receiving LED state updates
  def handle_info({:update_led_state, led_state}, socket) do
    {:noreply, assign(socket, :led_state, led_state)}
  end

  # Rendering the live view
  def render(assigns) do
    ~L"""
    <head>
      <!-- Title of the Reverse LED Website -->
      <title>The (Reverse) LED Website · Antonin TERRASSON</title>
    </head>

    <main>
      <!-- Title and link to the Reverse LED Website -->
      <div class="moitie-ecran" style="margin-top: 10%;">
        <h1 class="title">The (Reverse) LED Website<a href="https://www.youtube.com/watch?v=0U7SBGBCoGs&t=2m52s">®</a></h1>

        <!-- Visual representation of the LED state -->
        <div class="led-container <%= @led_state %>"></div>
      </div>

      <!-- Button to navigate back to the main LED control page -->
      <div style="text-align: center; margin-top: 3%;">
        <a href="/led" class="action-button back">Reverse</a>
      </div>
    </main>
    """
  end
end
