# This Elixir script defines a module, Firmware.FiniteAutomata, that represents a finite automaton controlling
# a gate with a servo motor, LEDs, and two switches. The script uses Circuits.GPIO for switch and LED control,
# and Pigpiox.GPIO for servo motor control. The GPIO pin configurations are retrieved from the application environment.
# The main loop continuously monitors the states of the switches, controls the gate and LED states based on the
# automaton logic, and broadcasts the switch and gate states using Phoenix.PubSub.

defmodule Firmware.FiniteAutomata do
  use Application

  @led_pin Application.compile_env(:finite_automata, :led_pin, 18) # GPIO pin for the LED

  # The entry point for the application.
  def start(_type, _args) do
    # Open GPIO pins for the LED and switches.
    {:ok, led_gpio} = Circuits.GPIO.open(@led_pin, :output)
    {:ok, sw_front_gpio} = Circuits.GPIO.open(23, :input)
    {:ok, sw_rear_gpio} = Circuits.GPIO.open(26, :input)

    # Set up the servo motor pin and initial pulsewidth.
    servomotor_pin = 16
    Pigpiox.GPIO.set_servo_pulsewidth(servomotor_pin, 1000)

    # Spawn a new process to run the loop function, allowing the application to perform other tasks concurrently.
    spawn(fn -> loop(sw_front_gpio, sw_rear_gpio, servomotor_pin, led_gpio) end)

    # Return an OK tuple to indicate successful start-up.
    {:ok, self()}
  end

  # Broadcasts the state of the front switch using Phoenix.PubSub.
  defp broadcast_sw_front_state(sw_front_state) do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_sw_front_state", {:update_sw_front_state, sw_front_state})
  end

  # Broadcasts the state of the rear switch using Phoenix.PubSub.
  defp broadcast_sw_rear_state(sw_rear_state) do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_sw_rear_state", {:update_sw_rear_state, sw_rear_state})
  end

  # Broadcasts the state of the gate using Phoenix.PubSub.
  defp broadcast_gate_state(gate_state) do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_gate_state", {:update_gate_state, gate_state})
  end

  # The main loop that monitors switch states, controls the gate, and updates the LED state.
  def loop(sw_front_gpio, sw_rear_gpio, servomotor_pin, led_gpio) do
    # Get the current pulsewidth of the servo motor.
    {:ok, servo_pulsewidth} = Pigpiox.GPIO.get_servo_pulsewidth(servomotor_pin)

    # Read the state of the front switch.
    sw_front_state = Circuits.GPIO.read(sw_front_gpio)

    # Broadcast the state of the front switch.
    if sw_front_state == 1 do
      broadcast_sw_front_state("")
    else
      broadcast_sw_front_state("front")
    end

    # Read the state of the rear switch.
    sw_rear_state = Circuits.GPIO.read(sw_rear_gpio)

    # Broadcast the state of the rear switch.
    if sw_rear_state == 1 do
      broadcast_sw_rear_state("")
    else
      broadcast_sw_rear_state("rear")
    end

    # Perform logic based on the current pulsewidth of the servo motor.
    case servo_pulsewidth do
      1000 ->
        Circuits.GPIO.write(led_gpio, 0)

        # If the front switch is pressed and the rear switch is not pressed, open the gate.
        if sw_front_state == 1 && sw_rear_state == 0 do
          Pigpiox.GPIO.set_servo_pulsewidth(servomotor_pin, 2000)
          broadcast_gate_state("opened")
        end

      2000 ->
        # Blink the LED.
        if System.os_time(:millisecond) |> rem(500) < 250 do
          Circuits.GPIO.write(led_gpio, 1)
        else
          Circuits.GPIO.write(led_gpio, 0)
        end

        # If both switches are not pressed, close the gate.
        if sw_front_state == 0 && sw_rear_state == 0 do
          Pigpiox.GPIO.set_servo_pulsewidth(servomotor_pin, 1000)
          broadcast_gate_state("")
        end

      _ ->
        Circuits.GPIO.write(led_gpio, 0)
        Pigpiox.GPIO.set_servo_pulsewidth(servomotor_pin, 1000)
    end

    # Pause execution for 100 milliseconds before the next iteration.
    :timer.sleep(100)

    # Recursively call the loop function to continue monitoring and updating the gate and LED states.
    loop(sw_front_gpio, sw_rear_gpio, servomotor_pin, led_gpio)
  end
end
