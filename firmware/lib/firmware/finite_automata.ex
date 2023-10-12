defmodule Firmware.FiniteAutomata do
  use Application

  # @ir_emitter_brightness 100
  # @ir_emitter_gpio 19
  # @ir_receiver_gpio 13

  @led_pin Application.compile_env(:finite_automata, :led_pin, 18) # broche GPIO pour la led

  def start(_type, _args) do

    # GPIO.set_mode(@ir_emitter_gpio, :output)
    # GPIO.set_mode(@ir_receiver_gpio, :input)

    {:ok, led_gpio} = Circuits.GPIO.open(@led_pin, :output)

    {:ok, sw_front_gpio} = Circuits.GPIO.open(23, :input)
    {:ok, sw_rear_gpio} = Circuits.GPIO.open(26, :input)

    servomotor_pin = 16
    Pigpiox.GPIO.set_servo_pulsewidth(servomotor_pin, 1000)

    spawn(fn -> loop(sw_front_gpio, sw_rear_gpio, servomotor_pin, led_gpio) end)
    {:ok, self()}
  end

  defp broadcast_sw_front_state(sw_front_state) do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_sw_front_state", {:update_sw_front_state, sw_front_state})
  end

  defp broadcast_sw_rear_state(sw_rear_state) do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_sw_rear_state", {:update_sw_rear_state, sw_rear_state})
  end

  defp broadcast_gate_state(gate_state) do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_gate_state", {:update_gate_state, gate_state})
  end

  # defp loop(ir_emitter_gpio, ir_receiver_gpio, servomotor_gpio) do
  def loop(sw_front_gpio, sw_rear_gpio, servomotor_pin, led_gpio) do

    {:ok, servo_pulsewidth} = Pigpiox.GPIO.get_servo_pulsewidth(servomotor_pin)

    sw_front_state = Circuits.GPIO.read(sw_front_gpio)

    if sw_front_state == 1 do
      broadcast_sw_front_state("")
    else
      broadcast_sw_front_state("front")
    end

    sw_rear_state = Circuits.GPIO.read(sw_rear_gpio)

    if sw_rear_state == 1 do
      broadcast_sw_rear_state("")
    else
      broadcast_sw_rear_state("rear")
    end

    case servo_pulsewidth do
      1000 ->
        Circuits.GPIO.write(led_gpio, 0)

        if sw_front_state == 1 && sw_rear_state == 0 do
          Pigpiox.GPIO.set_servo_pulsewidth(servomotor_pin, 2000)
          broadcast_gate_state("opened")
        end

      2000 ->
        # Clignotement de la LED
        if System.os_time(:millisecond) |> rem(500) < 250 do
          Circuits.GPIO.write(led_gpio, 1)
        else
          Circuits.GPIO.write(led_gpio, 0)
        end

        if sw_front_state == 0 && sw_rear_state == 0 do
          Pigpiox.GPIO.set_servo_pulsewidth(servomotor_pin, 1000)
          broadcast_gate_state("")
        end

      _ ->
        Circuits.GPIO.write(led_gpio, 0)
        Pigpiox.GPIO.set_servo_pulsewidth(servomotor_pin, 1000)
    end

    :timer.sleep(100)
    loop(sw_front_gpio, sw_rear_gpio, servomotor_pin, led_gpio)
  end

end
