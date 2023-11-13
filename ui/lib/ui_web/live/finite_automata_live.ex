# UiWeb.FiniteAutomataLive:
# This module defines a LiveView component for the Finite Automata Website. It subscribes
# to Phoenix PubSub channels for real-time updates on the states of switches (front and rear)
# and the gate. The visual representation includes stickman figures with switch indicators
# and gate status. The table below provides a clear mapping of switch states to gate conditions.

defmodule UiWeb.FiniteAutomataLive do
  # Use the UiWeb live view functionality
  use UiWeb, :live_view

  # Initial mount of the live view
  def mount(_params, _session, socket) do
    # Subscribe to PubSub channels for switch and gate state updates
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_sw_front_state")
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_sw_rear_state")
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_gate_state")
    {:ok, assign(socket, sw_front_state: "", sw_rear_state: "", gate_state: "")}
  end

  # Event handlers for receiving switch and gate state updates
  def handle_info({:update_sw_front_state, sw_front_state}, socket) do
    {:noreply, assign(socket, :sw_front_state, sw_front_state)}
  end

  def handle_info({:update_sw_rear_state, sw_rear_state}, socket) do
    {:noreply, assign(socket, :sw_rear_state, sw_rear_state)}
  end

  def handle_info({:update_gate_state, gate_state}, socket) do
    {:noreply, assign(socket, :gate_state, gate_state)}
  end

  # Rendering the live view
  def render(assigns) do
    ~L"""
    <head>
      <!-- Title of the Finite Automata Website -->
      <title>Finite Automata · Antonin TERRASSON</title>
    </head>

    <main>
      <!-- Title and link to the Finite Automata Website -->
      <div style="margin-top: 3%;" class="moitie-ecran">
        <h1 class="title">Finite Automata<a href="https://www.youtube.com/watch?v=0U7SBGBCoGs&t=2m52s">®</a></h1>

        <!-- Stickman figures with switch indicators -->
        <div class="stickman mt-10" style="left:25%;">Front
          <div class="head"></div>
          <div class="body"></div>
          <div class="right-arm"></div>
          <div class="left-arm"></div>
          <div class="left-leg"></div>
          <div class="right-leg"></div>
          <div class="<%= @sw_front_state %>"></div>
        </div>

        <div class="stickman mt-10" style="right:25%;">Rear
          <div class="head"></div>
          <div class="body"></div>
          <div class="right-arm"></div>
          <div class="left-arm"></div>
          <div class="left-leg"></div>
          <div class="right-leg"></div>
          <div class="<%= @sw_rear_state %>"></div>
        </div>

        <!-- Gate representation -->
        <div class="gate-1"></div>
        <div class="gate-2"></div>
        <div class="gate-3"></div>
        <div class="gate-door <%= @gate_state %>"></div>

        <!-- Table mapping switch states to gate conditions -->
        <table class="tableau">
          <tr>
              <td></td>
              <td style="background-color: #333333b7;">NEITHER</td>
              <td style="background-color: #FFA07A;">FRONT</td>
              <td style="background-color: #87CEEB;">REAR</td>
              <td style="background-color: #333333b7;">BOTH</td>
          </tr>
          <tr>
              <td style="background-color: #e57373;">CLOSED</td>
              <td>CLOSED</td>
              <td>OPEN</td>
              <td>CLOSED</td>
              <td>CLOSED</td>
          </tr>
          <tr>
              <td style="background-color: #a2d6ab;">OPEN</td>
              <td>CLOSED</td>
              <td>OPEN</td>
              <td>OPEN</td>
              <td>OPEN</td>
          </tr>
        </table>
      </div>
    </main>
    """
  end
end
