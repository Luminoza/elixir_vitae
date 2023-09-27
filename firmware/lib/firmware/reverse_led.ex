defmodule Firmware.ReverseLed do
  use Application

  alias Circuits.GPIO

  @sw_pin Application.compile_env(:reverse_led, :sw_pin, 17) # broche GPIO pour le switch
  @led_sw_pin Application.compile_env(:reverse_led, :led_sw_pin, 27) # broche GPIO pour la led

  def start(_type, _args) do

    {:ok, sw_gpio} = GPIO.open(@sw_pin, :input)
    {:ok, led_sw_gpio} = GPIO.open(@led_sw_pin, :output)

    spawn(fn -> loop(sw_gpio, led_sw_gpio) end)
    {:ok, self()}
  end

  defp broadcast_led_state(led_state) do
    Phoenix.PubSub.broadcast(Ui.PubSub, "update_led_state", {:update_led_state, led_state})
  end

  defp loop(sw_gpio, led_sw_gpio) do

    button_state = GPIO.read(sw_gpio)

      if button_state == 1 do
        GPIO.write(led_sw_gpio, 1)

        Ui.Manager.set_button_pressed(true)
        broadcast_led_state("led-on")
      else
        GPIO.write(led_sw_gpio, 0)

        Ui.Manager.set_button_pressed(false)
        broadcast_led_state("led-off")
    end

    :timer.sleep(100)
    loop(sw_gpio, led_sw_gpio)
  end
end
