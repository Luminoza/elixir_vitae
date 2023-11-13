# This module defines the live view for the Mystery Website. It includes functions for mounting the live view,
# handling events such as toggling the mystery state, and rendering the view with appropriate HTML and styles.

defmodule UiWeb.MysteryLive do
  use UiWeb, :live_view

  # Mount the live view
  def mount(_params, _session, socket) do
    {:ok, assign(socket, mystery: false)}
  end

  # Handle the "mystery" event
  def handle_event("mystery", _, socket) do
    # Toggle the mystery state
    new_mystery = not socket.assigns.mystery

    # Set the mystery state in the manager
    Ui.Manager.set_mystery(new_mystery)

    # Update the live view's assigns with the new mystery state
    {:noreply, assign(socket, mystery: new_mystery)}
  end

  # Render the live view
  def render(assigns) do
    ~H"""
    <head>
      <title>The Mystery Website · Antonin TERRASSON</title>
    </head>

    <main style="margin-top: 5%;">
      <h1 class="title moitie-ecran">The Mystery Website<a href="https://www.youtube.com/watch?v=ILtz5nX3_fc&t=1m01s">®</a></h1>

      <div style="text-align: center; margin-top: 3%;">
        <!-- Mystery button with a click event -->
        <button class="mystery-button" phx-click="mystery">
          <span>Mystery</span>
        </button>
      </div>

    </main>
    """
  end
end
