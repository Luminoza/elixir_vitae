defmodule UiWeb.MysteryLive do
  use UiWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, mystery: false)}
  end

  def handle_event("mystery", _, socket) do
    new_mystery = not socket.assigns.mystery
    Ui.Manager.set_mystery(new_mystery)
    {:noreply, assign(socket, mystery: new_mystery)}
  end

  def render(assigns) do
    ~H"""
    <head>
      <title>The Mystery Website · Antonin TERRASSON</title>
    </head>

    <main class="moitie-ecran">
      <h1 class="title">The Mystery Website<a href="https://www.youtube.com/watch?v=ILtz5nX3_fc&t=1m01s">®</a></h1>

      <button class="mystery-button mt-10" phx-click="mystery">
        <span>Mystery</span>
      </button>

    </main>
    """
  end

end
