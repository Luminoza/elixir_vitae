defmodule UiWeb.FiniteAutomataLive do
  use UiWeb, :live_view

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_sw_front_state")
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_sw_rear_state")
    Phoenix.PubSub.subscribe(Ui.PubSub, "update_gate_state")
    {:ok, assign(socket, sw_front_state: "", sw_rear_state: "", gate_state: "")}
  end

  ##############

  # Boutton Physique

  def handle_info({:update_sw_front_state, sw_front_state}, socket) do
    {:noreply, assign(socket, :sw_front_state, sw_front_state)}
  end

  def handle_info({:update_sw_rear_state, sw_rear_state}, socket) do
    {:noreply, assign(socket, :sw_rear_state, sw_rear_state)}
  end

  def handle_info({:update_gate_state, gate_state}, socket) do
    {:noreply, assign(socket, :gate_state, gate_state)}
  end

  ##############

  def render(assigns) do
    ~L"""
    <head>
      <title>Finite Automata · Antonin TERRASSON</title>
    </head>

    <main>
      <div style="margin-top: 3%;" class="moitie-ecran">
        <h1 class="title">Finite Automata<a href="https://www.youtube.com/watch?v=0U7SBGBCoGs&t=2m52s">®</a></h1>

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

        <div class="gate-1"></div>
        <div class="gate-2"></div>
        <div class="gate-3"></div>
        <div class="gate-door <%= @gate_state %>"></div>

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
