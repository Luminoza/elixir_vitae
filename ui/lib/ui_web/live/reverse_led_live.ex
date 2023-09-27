defmodule UiWeb.ReverseLedLive do
  use UiWeb, :live_view

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_led_state")
    {:ok, assign(socket, led_state: "led-off")}
  end

  ##############

  # Boutton Physique

  def handle_info({:update_led_state, led_state}, socket) do
    {:noreply, assign(socket, :led_state, led_state)}
  end

  ##############

  def render(assigns) do
    ~L"""
    <head>
      <title>The (Reverse) LED Website · Antonin TERRASSON</title>
    </head>

    <main class="moitie-ecran">
      <h1 class="title">The (Reverse) LED Website<a href="https://www.youtube.com/watch?v=0U7SBGBCoGs&t=2m52s">®</a></h1>

      <div class="led-container <%= @led_state %>"></div>

      <div class="mt-10">
        <a href="/led" class="action-button back">Reverse</a>
      </div>
    </main>
    """
  end
end
