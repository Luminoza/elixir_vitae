# This Elixir script defines a module, Firmware.Tetris, that interacts with GPIO pins to simulate Tetris game controls.
# The script uses Circuits.GPIO for switch control and Pigpiox.Pwm for LED control. GPIO pin configurations are retrieved
# from the application environment. The main loop continuously monitors the state of switches, controls LEDs based on
# switch states, and broadcasts the switch states using Phoenix.PubSub.

defmodule Firmware.Tetris do
  use Application

  alias Pigpiox.Pwm
  alias Circuits.GPIO

  ##------------- Pins --------------##

  # GPIO pin configurations for switches (uncomment and adjust as needed).
  @sw_pin_right Application.compile_env(:tetris, :sw_pin_right, 9)
  @sw_pin_left Application.compile_env(:tetris, :sw_pin_left, 11)
  @sw_pin_gravity Application.compile_env(:tetris, :sw_pin_gravity, 21)
  @sw_pin_turn Application.compile_env(:tetris, :sw_pin_turn, 20)

  ##------------- Start --------------##

  # The entry point for the application.
  def start(_type, _args) do
    # Open GPIO pins for switches.
    {:ok, sw_gpio_right} = GPIO.open(@sw_pin_right, :input)
    {:ok, sw_gpio_left} = GPIO.open(@sw_pin_left, :input)
    {:ok, sw_gpio_gravity} = GPIO.open(@sw_pin_gravity, :input)
    {:ok, sw_gpio_turn} = GPIO.open(@sw_pin_turn, :input)

    # GPIO pins for RGB LEDs.
    red_gpio = 12
    green_gpio = 13
    blue_gpio = 19

    # Spawn a new process to run the loop function, allowing the application to perform other tasks concurrently.
    spawn(fn -> loop(sw_gpio_right, sw_gpio_left, sw_gpio_gravity, sw_gpio_turn, red_gpio, green_gpio, blue_gpio) end)

    # Return an OK tuple to indicate successful start-up.
    {:ok, self()}
  end

  ##------------- Envoie --------------##

  # Broadcast switch states using Phoenix.PubSub.
  def broadcast_right() do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_right_state", :update_right_state)
  end

  def broadcast_left() do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_left_state", :update_left_state)
  end

  def broadcast_gravity() do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_gravity_state", :update_gravity_state)
  end

  def broadcast_turn() do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_turn_state", :update_turn_state)
  end

  ##------------- Loop --------------##

  # The main loop that monitors switch states, controls LEDs, and broadcasts switch states.
  defp loop(sw_gpio_right, sw_gpio_left, sw_gpio_gravity, sw_gpio_turn, red_gpio, green_gpio, blue_gpio) do

    #-- Right --#

    button_right_state = GPIO.read(sw_gpio_right)
    if button_right_state == 1 do
      Pwm.gpio_pwm(green_gpio, 255)

      Ui.Manager.set_button_right_pressed(true)
      broadcast_right()
    else
      Pwm.gpio_pwm(green_gpio, 0)

      Ui.Manager.set_button_right_pressed(false)
    end

    #-- Left --#

    button_left_state = GPIO.read(sw_gpio_left)
    if button_left_state == 1 do
      Pwm.gpio_pwm(red_gpio, 255)

      Ui.Manager.set_button_left_pressed(true)
      broadcast_left()
    else
      Pwm.gpio_pwm(red_gpio, 0)
      Ui.Manager.set_button_left_pressed(false)
    end

    #-- Gravity --#

    button_gravity_state = GPIO.read(sw_gpio_gravity)
    if button_gravity_state == 1 do
      Pwm.gpio_pwm(blue_gpio, 255)

      Ui.Manager.set_button_gravity_pressed(true)
      broadcast_gravity()
    else
      Pwm.gpio_pwm(blue_gpio, 0)
      Ui.Manager.set_button_gravity_pressed(false)
    end

    #-- Turn --#

    button_turn_state = GPIO.read(sw_gpio_turn)
    if button_turn_state == 1 do
      Pwm.gpio_pwm(blue_gpio, 50)
      Pwm.gpio_pwm(green_gpio, 255)

      Ui.Manager.set_button_turn_pressed(true)
      broadcast_turn()
    else
      Pwm.gpio_pwm(blue_gpio, 0)
      Pwm.gpio_pwm(green_gpio, 0)
      Ui.Manager.set_button_turn_pressed(false)
    end

    #-- Time --#

    :timer.sleep(100)  # Adjust the duration based on the game speed
    loop(sw_gpio_right, sw_gpio_left, sw_gpio_gravity, sw_gpio_turn, red_gpio, green_gpio, blue_gpio)
  end
end
