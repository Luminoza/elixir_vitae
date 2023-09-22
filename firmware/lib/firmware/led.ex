defmodule Firmware.Led do
  use Application
  alias Pigpiox.Pwm

  def start(_type, _args) do
    output_gpio = 18
    spawn(fn -> loop(output_gpio) end)
    {:ok, self()}
  end

  defp loop(output_gpio) do
    case Ui.Manager.get_brightness() do
      100 ->
        Pwm.gpio_pwm(output_gpio, 255) # 100% max 255
      90 ->
        Pwm.gpio_pwm(output_gpio, 150)
      80 ->
        Pwm.gpio_pwm(output_gpio, 80)
      70 ->
        Pwm.gpio_pwm(output_gpio, 70)
      60 ->
        Pwm.gpio_pwm(output_gpio, 50)
      50 ->
        Pwm.gpio_pwm(output_gpio, 40)
      40 ->
        Pwm.gpio_pwm(output_gpio, 30)
      30 ->
        Pwm.gpio_pwm(output_gpio, 20)
      20 ->
        Pwm.gpio_pwm(output_gpio, 10)
      10 ->
        Pwm.gpio_pwm(output_gpio, 5)
      0 ->
        Pwm.gpio_pwm(output_gpio, 0) # 0%
    end

    Process.sleep(100)  # Ajuste la durée en fonction de la luminosité
    loop(output_gpio)
  end
end
