defmodule Ui.Manager do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{brightness: 0, button_pressed: False, x: 0.0, y: 0.0, angle: 0.0, speed: 0.0, mystery: False}, name: :ui_manager)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end



  # The LED Website
  @impl true
  def handle_call({:set_brightness, new_brightness}, _from, state) do
    {:reply, :ok, %{state | brightness: new_brightness}}
  end

  @impl true
  def handle_call(:get_brightness, _from, state) do
    {:reply, state.brightness, state}
  end



  # The (Reverse) LED Website
  @impl true
  def handle_call({:set_button_pressed, new_button_pressed}, _from, state) do
    {:reply, :ok, %{state | button_pressed: new_button_pressed}}
    #|> Phoenix.LiveView.send_update(__MODULE__, to: UiWeb.ReverseLed, event: :updated_button_pressed)
  end

  @impl true
  def handle_call(:get_button_pressed, _from, state) do
    {:reply, state.button_pressed, state}
  end



  # The Mystery Website
  @impl true
  def handle_call({:set_mystery, new_mystery}, _from, state) do
    {:reply, :ok, %{state | mystery: new_mystery}}
  end

  @impl true
  def handle_call(:get_mystery, _from, state) do
    {:reply, state.mystery, state}
    # Process.sleep(1000)
    # Ui.Manager.set_mystery(False)
    # {:reply, state.mystery, state}
  end



  # The Joystick Website
  @impl true
  def handle_call({:set_joystick, new_x, new_y, new_angle, new_speed}, _from, state) do
    {:reply, :ok, %{state | x: new_x, y: new_y, angle: new_angle, speed: new_speed}}
  end

  @impl true
  def handle_call(:get_joystick, _from, state) do
    {:reply, {state.x, state.y, state.angle, state.speed}, state}
  end


  ################
  ### User API ###
  ################

  # The LED Website

  def set_brightness(brightness) do
    GenServer.call(:ui_manager, {:set_brightness, brightness})
  end

  def get_brightness() do
    GenServer.call(:ui_manager, :get_brightness)
  end



  # The (Reverse) LED Website

  def set_button_pressed(button_pressed) do
    GenServer.call(:ui_manager, {:set_button_pressed, button_pressed})
  end

   def get_button_pressed() do
     GenServer.call(:ui_manager, :get_button_pressed)
   end



  # The Mystery Website

  def set_mystery(mystery) do
    GenServer.call(:ui_manager, {:set_mystery, mystery})
  end

  def get_mystery() do
    GenServer.call(:ui_manager, :get_mystery)
  end



  # The Joystick Website

  def set_joystick(x, y, angle, speed) do
    GenServer.call(:ui_manager, {:set_joystick, x, y, angle, speed})
  end

  def get_joystick() do
    GenServer.call(:ui_manager, :get_joystick)
  end

end




# defmodule UiWeb.LedSocket do
#   use Phoenix.Socket

#   ## Channels
#   channel "led:*", UiWeb.LedChannel
# end

# defmodule UiWeb.LedChannel do
#   use Phoenix.Channel

#   def join("led:lobby", _params, socket) do
#     {:ok, socket}
#   end

#   def handle_in("sw_change", _params, socket) do
#     # Mise à jour de l'état de la LED
#     new_led_state = "led-on" # ou "led-off" en fonction de la logique de votre application

#     # Envoi d'un message au LiveView pour mettre à jour l'état
#     {:noreply, _, socket} = Phoenix.LiveView.broadcast(socket, "led_state_update", %{led_state: new_led_state})

#     {:noreply, socket}
#   end

# end
