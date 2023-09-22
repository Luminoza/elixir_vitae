defmodule Firmware.ReverseLed do
  use Application

  alias Circuits.GPIO

  @sw_pin Application.compile_env(:reverse_led, :sw_pin, 17) # broche GPIO pour le switch
  @led_sw_pin Application.compile_env(:reverse_led, :led_sw_pin, 27) # broche GPIO pour la led

  def start(_type, _args) do

    {:ok, sw_gpio} = GPIO.open(@sw_pin, :input)
    {:ok, led_sw_gpio} = GPIO.open(@led_sw_pin, :output)

    last_button_state = :error

    spawn(fn -> loop(sw_gpio, led_sw_gpio , last_button_state) end)
    {:ok, self()}
  end

  defp change_led_state do
    # send(UiWeb.ReverseLedLive, "sw_change")
    # send(UiWeb.ReverseLedLive, :sw_change)
    # UiWeb.Endpoint.broadcast("led:lobby", "sw_change", %{})
  end

  defp loop(sw_gpio, led_sw_gpio, last_button_state) do

    button_state = GPIO.read(sw_gpio)

    if button_state != last_button_state do
      if button_state == 1 do
        GPIO.write(led_sw_gpio, 1)

        Ui.Manager.set_button_pressed(true)
        change_led_state()
      else
        GPIO.write(led_sw_gpio, 0)

        Ui.Manager.set_button_pressed(false)
        change_led_state()
      end
      last_button_state = button_state
    end

    :timer.sleep(100)
    loop(sw_gpio, led_sw_gpio, last_button_state)
  end
end
