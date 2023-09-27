defmodule Firmware.RainbowLED do
  use Application
  alias Pigpiox.Pwm

  def start(_type, _args) do

    red_gpio = 12
    green_gpio = 13
    blue_gpio = 19

    spawn(fn -> loop(red_gpio, green_gpio, blue_gpio) end)
    {:ok, self()}
  end

  defp rainbow_color() do

    r = :rand.uniform(250)
    g = :rand.uniform(50)
    b = :rand.uniform(50)

    if r < 100 do
      rainbow_color()
    end

    {r, g, b}
  end

  defp loop(red_gpio, green_gpio, blue_gpio) do

    if Ui.Manager.get_mystery == true do

      {r, g, b} = rainbow_color()

      Pwm.gpio_pwm(red_gpio, r)
      Pwm.gpio_pwm(green_gpio, g)
      Pwm.gpio_pwm(blue_gpio, b)
    else
      Pwm.gpio_pwm(red_gpio, 0)
      Pwm.gpio_pwm(green_gpio, 0)
      Pwm.gpio_pwm(blue_gpio, 0)
    end

    Process.sleep(100)  # Ajuste la durée en fonction de la luminosité
    loop(red_gpio, green_gpio, blue_gpio)
  end
end
