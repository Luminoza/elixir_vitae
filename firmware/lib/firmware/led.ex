# This Elixir script defines a module, Firmware.Led, that controls the brightness of an LED using the Pigpiox library.
# The LED brightness is adjusted based on predefined levels, ranging from 0 to 100. The script utilizes the Ui.Manager
# module to retrieve the current brightness level and sets the PWM (Pulse Width Modulation) output on GPIO pin 18 accordingly.
# The PWM values are mapped to different brightness levels, with 0 representing off and 255 representing 100% brightness.
# The script runs in a loop, continuously updating the LED brightness based on the current brightness level retrieved from Ui.Manager.
# The duration of each iteration is adjusted with Process.sleep(100) to control the speed of the brightness changes.
# This script is designed to be a part of a larger firmware application and serves as an example of how to interface with GPIO
# and manage LED brightness in an Elixir application.

defmodule Firmware.Led do
  use Application
  alias Pigpiox.Pwm

  # The entry point for the application.
  def start(_type, _args) do
    output_gpio = 18

    # Spawn a new process to run the loop function, allowing the application to perform other tasks concurrently.
    spawn(fn -> loop(output_gpio) end)

    # Return an OK tuple to indicate successful start-up.
    {:ok, self()}
  end

  # The main loop that controls the LED brightness.
  defp loop(output_gpio) do
    # Retrieve the current brightness level from the Ui.Manager module.
    case Ui.Manager.get_brightness() do
      100 ->
        Pwm.gpio_pwm(output_gpio, 255) # Set PWM to 100% (max value is 255)
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
        Pwm.gpio_pwm(output_gpio, 0) # Set PWM to 0% (off)
    end

    # Pause execution for 100 milliseconds. Adjust the duration based on the desired speed of brightness changes.
    Process.sleep(100)

    # Recursively call the loop function to continue monitoring and adjusting the LED brightness.
    loop(output_gpio)
  end
end
