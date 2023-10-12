defmodule Ui.Manager do
  use GenServer

  ##------------- Start --------------##

  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      %{
        brightness: 0,

        button_pressed: false,

        button_front_pressed: false,
        button_rear_pressed: false,

        button_right_pressed: false,
        button_left_pressed: false,
        button_gravity_pressed: false,
        button_turn_pressed: false,

        x: 0.0, y: 0.0, angle: 0.0, speed: 0.0,

        mystery: false
      },

      name: :ui_manager)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end


  ##------------- The LED Website --------------##

  @impl true
  def handle_call({:set_brightness, new_brightness}, _from, state) do
    {:reply, :ok, %{state | brightness: new_brightness}}
  end

  @impl true
  def handle_call(:get_brightness, _from, state) do
    {:reply, state.brightness, state}
  end


  ##------------- The (Reverse) LED Website --------------##

  @impl true
  def handle_call({:set_button_pressed, new_button_pressed}, _from, state) do
    {:reply, :ok, %{state | button_pressed: new_button_pressed}}
  end

  @impl true
  def handle_call(:get_button_pressed, _from, state) do
    {:reply, state.button_pressed, state}
  end


  ##------------- The Tetris Website --------------##

  #-- Right --#

  @impl true
  def handle_call({:set_button_right_pressed, new_button_right_pressed}, _from, state) do
    {:reply, :ok, %{state | button_right_pressed: new_button_right_pressed}}
  end
  @impl true
  def handle_call(:get_button_right_pressed, _from, state) do
    {:reply, state.button_right_pressed, state}
  end

  #-- Left --#

  @impl true
  def handle_call({:set_button_left_pressed, new_button_left_pressed}, _from, state) do
    {:reply, :ok, %{state | button_left_pressed: new_button_left_pressed}}
  end
  @impl true
  def handle_call(:get_button_left_pressed, _from, state) do
    {:reply, state.button_left_pressed, state}
  end

  #-- Gravity --#

  @impl true
  def handle_call({:set_button_gravity_pressed, new_button_gravity_pressed}, _from, state) do
    {:reply, :ok, %{state | button_gravity_pressed: new_button_gravity_pressed}}
  end
  @impl true
  def handle_call(:get_button_gravity_pressed, _from, state) do
    {:reply, state.button_gravity_pressed, state}
  end

  #-- Turn --#

  @impl true
  def handle_call({:set_button_turn_pressed, new_button_turn_pressed}, _from, state) do
    {:reply, :ok, %{state | button_turn_pressed: new_button_turn_pressed}}
  end
  @impl true
  def handle_call(:get_button_turn_pressed, _from, state) do
    {:reply, state.button_turn_pressed, state}
  end


  ##------------- The Joystick Website --------------##

  @impl true
  def handle_call({:set_joystick, new_x, new_y, new_angle, new_speed}, _from, state) do
    {:reply, :ok, %{state | x: new_x, y: new_y, angle: new_angle, speed: new_speed}}
  end

  @impl true
  def handle_call(:get_joystick, _from, state) do
    {:reply, {state.x, state.y, state.angle, state.speed}, state}
  end

  ##------------- Finite Automata --------------##

  @impl true
  def handle_call({:set_button_front_pressed, new_button_front_pressed}, _from, state) do
    {:reply, :ok, %{state | button_front_pressed: new_button_front_pressed}}
  end

  @impl true
  def handle_call({:set_button_rear_pressed, new_button_rear_pressed}, _from, state) do
    {:reply, :ok, %{state | button_rear_pressed: new_button_rear_pressed}}
  end


  ##------------- The Mystery Website --------------##

  @impl true
  def handle_call({:set_mystery, new_mystery}, _from, state) do
    {:reply, :ok, %{state | mystery: new_mystery}}
  end

  @impl true
  def handle_call(:get_mystery, _from, state) do
    {:reply, state.mystery, state}
  end


  ################################################################################
  ################################### User API ###################################
  ################################################################################


  ##------------- The Tetris Website --------------##

  def set_brightness(brightness) do
    GenServer.call(:ui_manager, {:set_brightness, brightness})
  end

  def get_brightness() do
    GenServer.call(:ui_manager, :get_brightness)
  end



  ##------------- The (Reverse) LED Website --------------##

  def set_button_pressed(button_pressed) do
    GenServer.call(:ui_manager, {:set_button_pressed, button_pressed})
  end

  def get_button_pressed() do
    GenServer.call(:ui_manager, :get_button_pressed)
  end


  ##------------- The Tetris Website --------------##

  #-- Right --#

  def set_button_right_pressed(button_right_pressed) do
    GenServer.call(:ui_manager, {:set_button_right_pressed, button_right_pressed})
  end
  def get_button_right_pressed() do
    GenServer.call(:ui_manager, :get_button_right_pressed)
  end

  #-- Left --#

  def set_button_left_pressed(button_left_pressed) do
    GenServer.call(:ui_manager, {:set_button_left_pressed, button_left_pressed})
  end
  def get_button_left_pressed() do
    GenServer.call(:ui_manager, :get_button_left_pressed)
  end

  #-- Gravity --#

  def set_button_gravity_pressed(button_gravity_pressed) do
    GenServer.call(:ui_manager, {:set_button_gravity_pressed, button_gravity_pressed})
  end
  def get_button_gravity_pressed() do
    GenServer.call(:ui_manager, :get_button_gravity_pressed)
  end

  #-- Turn --#

  def set_button_turn_pressed(button_turn_pressed) do
    GenServer.call(:ui_manager, {:set_button_turn_pressed, button_turn_pressed})
  end
  def get_button_turn_pressed() do
    GenServer.call(:ui_manager, :get_button_turn_pressed)
  end


  ##------------- The Joystick Website --------------##

  def set_joystick(x, y, angle, speed) do
    GenServer.call(:ui_manager, {:set_joystick, x, y, angle, speed})
  end

  def get_joystick() do
    GenServer.call(:ui_manager, :get_joystick)
  end


  ##------------- The (Reverse) LED Website --------------##

  def set_button_front_pressed(button_front_pressed) do
    GenServer.call(:ui_manager, {:set_button_front_pressed, button_front_pressed})
  end

  def set_button_rear_pressed(button_rear_pressed) do
    GenServer.call(:ui_manager, {:set_button_rear_pressed, button_rear_pressed})
  end


  ##------------- The Mystery Website --------------##

  def set_mystery(mystery) do
    GenServer.call(:ui_manager, {:set_mystery, mystery})
  end

  def get_mystery() do
    GenServer.call(:ui_manager, :get_mystery)
  end

end
