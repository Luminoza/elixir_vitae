# This Elixir script defines a module, Firmware.ReverseLed, that manages the state of a LED based on a switch's input.
# The script uses the Circuits.GPIO library to interact with GPIO pins for both the switch and the LED. The GPIO pin
# configurations are retrieved from the application environment, and the LED state is broadcasted using Phoenix.PubSub.
# The main loop continuously monitors the state of the switch, updates the LED state accordingly, and broadcasts the
# updated state to the Ui.PubSub module.

defmodule Firmware.ReverseLed do
  use Application

  alias Circuits.GPIO

  @sw_pin Application.compile_env(:reverse_led, :sw_pin, 17) # GPIO pin for the switch
  @led_sw_pin Application.compile_env(:reverse_led, :led_sw_pin, 27) # GPIO pin for the LED

  # The entry point for the application.
  def start(_type, _args) do
    # Open GPIO pins for the switch and LED.
    {:ok, sw_gpio} = GPIO.open(@sw_pin, :input)
    {:ok, led_sw_gpio} = GPIO.open(@led_sw_pin, :output)

    # Spawn a new process to run the loop function, allowing the application to perform other tasks concurrently.
    spawn(fn -> loop(sw_gpio, led_sw_gpio) end)

    # Return an OK tuple to indicate successful start-up.
    {:ok, self()}
  end

  # Broadcasts the current LED state using Phoenix.PubSub.
  defp broadcast_led_state(led_state) do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_led_state", {:update_led_state, led_state})
  end

  # The main loop that monitors the switch state and updates the LED state accordingly.
  defp loop(sw_gpio, led_sw_gpio) do
    # Read the current state of the switch.
    button_state = GPIO.read(sw_gpio)

    # Update the LED state and broadcast the change based on the switch state.
    if button_state == 1 do
      GPIO.write(led_sw_gpio, 1) # Turn on the LED

      Ui.Manager.set_button_pressed(true)
      broadcast_led_state("led-on")
    else
      GPIO.write(led_sw_gpio, 0) # Turn off the LED

      Ui.Manager.set_button_pressed(false)
      broadcast_led_state("led-off")
    end

    # Pause execution for 100 milliseconds before the next iteration.
    :timer.sleep(100)

    # Recursively call the loop function to continue monitoring and updating the LED state.
    loop(sw_gpio, led_sw_gpio)
  end
end
