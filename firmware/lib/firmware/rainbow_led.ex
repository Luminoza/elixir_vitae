# This Elixir script defines a module, Firmware.RainbowLED, that controls RGB LEDs to simulate a rainbow effect.
# The script uses Pigpiox.Pwm for LED control and includes a function to generate random rainbow colors.
# The main loop continuously checks for a flag from Ui.Manager to determine whether to display the rainbow effect.

defmodule Firmware.RainbowLED do
  use Application
  alias Pigpiox.Pwm

  # The entry point for the application.
  def start(_type, _args) do
    # GPIO pins for RGB LEDs.
    red_gpio = 12
    green_gpio = 13
    blue_gpio = 19

    # Spawn a new process to run the loop function, allowing the application to perform other tasks concurrently.
    spawn(fn -> loop(red_gpio, green_gpio, blue_gpio) end)

    # Return an OK tuple to indicate successful start-up.
    {:ok, self()}
  end

  # Function to generate a random rainbow color.
  defp rainbow_color() do
    r = :rand.uniform(250)
    g = :rand.uniform(50)
    b = :rand.uniform(50)

    # Ensure that the red component is significant to make the color more vibrant.
    if r < 100 do
      rainbow_color()
    end

    {r, g, b}
  end

  # The main loop that controls the RGB LEDs based on the rainbow effect flag from Ui.Manager.
  defp loop(red_gpio, green_gpio, blue_gpio) do
    # Check if the rainbow effect flag is set in Ui.Manager.
    if Ui.Manager.get_mystery == true do
      # Generate a random rainbow color.
      {r, g, b} = rainbow_color()

      # Set the PWM values for the RGB LEDs to create the rainbow effect.
      Pwm.gpio_pwm(red_gpio, r)
      Pwm.gpio_pwm(green_gpio, g)
      Pwm.gpio_pwm(blue_gpio, b)
    else
      # Turn off the RGB LEDs if the rainbow effect flag is not set.
      Pwm.gpio_pwm(red_gpio, 0)
      Pwm.gpio_pwm(green_gpio, 0)
      Pwm.gpio_pwm(blue_gpio, 0)
    end

    # Pause execution for 100 milliseconds before the next iteration.
    Process.sleep(100)

    # Recursively call the loop function to continue controlling the RGB LEDs.
    loop(red_gpio, green_gpio, blue_gpio)
  end
end
