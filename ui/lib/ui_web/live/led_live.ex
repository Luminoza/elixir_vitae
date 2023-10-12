defmodule UiWeb.LedLive do
  use UiWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, brightness: 0)}
  end

  def handle_event("on", _, socket) do
    Ui.Manager.set_brightness(100)
    {:noreply, assign(socket, brightness: 100)}
  end

  def handle_event("up", _, socket) do
    new_brightness = min(socket.assigns.brightness + 10, 100)
    Ui.Manager.set_brightness(new_brightness)
    {:noreply, assign(socket, brightness: new_brightness)}
  end

  def handle_event("off", _, socket) do
    Ui.Manager.set_brightness(0)
    {:noreply, assign(socket, brightness: 0)}
  end

  def handle_event("down", _, socket) do
    new_brightness = max(socket.assigns.brightness - 10, 0)
    Ui.Manager.set_brightness(new_brightness)
    {:noreply, assign(socket, brightness: new_brightness)}
  end

  def render(assigns) do
    ~H"""
    <head>
      <title>The LED Website · Antonin TERRASSON</title>
    </head>

    <main style="margin-top: 6%;" class="moitie-ecran">
      <h1 class="title">The LED Website<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">®</a></h1>

      <div id="light" class="mt-20">
        <div class="meter">
          <span style={"width: #{@brightness}%"}>
            <%= @brightness %>%
          </span>
        </div>

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

        <a href="/led/reverseled" class="action-button reverse">Reverse</a>
      </div>
    </main>
    """
  end

end
