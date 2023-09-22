defmodule UiWeb.ReverseLedLive do
  use UiWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, led_state: "led-off")}
  end

  def led("led-off", socket), do: assign(socket, led_state: "led-on")
  def led("led-on", socket), do: assign(socket, led_state: "led-off")


  def handle_event("sw_change", _, socket) do
    {:noreply, led(socket.assigns.led_state, socket)}
  end

  def handle_event(:sw_change, _, socket) do
    {:noreply, led(socket.assigns.led_state, socket)}
  end

  def render(assigns) do
    ~L"""
    <head>
      <title>The (Reverse) LED Website · Antonin TERRASSON</title>
    </head>

    <main class="moitie-ecran">
      <h1 class="title">The (Reverse) LED Website<a href="https://www.youtube.com/watch?v=0U7SBGBCoGs&t=2m52s">®</a></h1>

      <button class="action-button onoff" phx-click="sw_change">ON / OFF</button>

      <div class="led-container <%= @led_state %>"></div>
      <div class="led-container <%= if (Ui.Manager.get_button_pressed == true), do: "led-on" %>"></div>

      <div class="mt-10">
        <a href="/led" class="action-button back">Reverse</a>
      </div>
    </main>
    """
  end
end
