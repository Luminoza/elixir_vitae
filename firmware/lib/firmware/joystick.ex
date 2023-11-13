# This Elixir script defines a module, Firmware.Joystick, that reads values from a joystick connected to GPIO pins
# and calculates the angle, speed, and LED states based on the joystick's position. The script utilizes the Pigpiox.GPIO
# library for GPIO interactions. The GPIO pin configurations and other settings are retrieved from the application environment.
# The main loop continuously reads joystick values, calculates parameters, updates LED states, and sends joystick data to a GenServer.

defmodule Firmware.Joystick do
  # Commenting out the unused directives to avoid compilation errors.
  # use Application
  # alias Circuits.GPIO

  # GPIO pin configurations for the joystick and LEDs (uncomment and adjust as needed).
  # @x_pin Application.compile_env(:joystick, :x_pin, 13) # GPIO pin for the X-axis
  # @y_pin Application.compile_env(:joystick, :y_pin, 18) # GPIO pin for the Y-axis
  # @led_x_pin Application.compile_env(:joystick, :led_x_pin, 10) # GPIO pin for the LED associated with X-axis
  # @led_y_pin Application.compile_env(:joystick, :led_y_pin, 9) # GPIO pin for the LED associated with Y-axis

  # Speed threshold for LED activation (adjust as needed).
  # @speed_threshold 50

  # The entry point for the application.
  # def start(_type, _args) do
  #   # GPIO pins for X and Y axes (uncomment and adjust as needed).
  #   x_gpio = 13
  #   y_gpio = 18

  #   # Set GPIO modes for X and Y axes.
  #   Pigpiox.GPIO.set_mode(x_gpio, :input)
  #   Pigpiox.GPIO.set_mode(y_gpio, :input)

  #   # Open GPIO pins for the LEDs.
  #   {:ok, led_x_gpio} = GPIO.open(@led_x_pin, :output)
  #   {:ok, led_y_gpio} = GPIO.open(@led_y_pin, :output)

  #   # Spawn a new process to run the loop function, allowing the application to perform other tasks concurrently.
  #   spawn(fn -> loop(x_gpio, y_gpio, led_x_gpio, led_y_gpio) end)

  #   # Return an OK tuple to indicate successful start-up.
  #   {:ok, self()}
  # end

  # The main loop that reads joystick values, calculates parameters, updates LED states, and sends data to a GenServer.
  # defp loop(x_gpio, y_gpio, led_x_gpio, led_y_gpio) do
  #   # Read values from X and Y axes.
  #   {:ok, x_value} = Pigpiox.GPIO.read(x_gpio)
  #   {:ok, y_value} = Pigpiox.GPIO.read(y_gpio)

  #   # Calculate angle in radians and degrees.
  #   angle_radians = :math.atan2(y_value, x_value)
  #   angle_degrees = ((angle_radians * 180) / 3.14)

  #   # Calculate speed percentage using the distance of normalized values.
  #   distance = :math.sqrt(x_value * x_value + y_value * y_value)
  #   speed_percentage = distance * 100

  #   # Send joystick data to the GenServer.
  #   Ui.Manager.set_joystick(x_value, y_value, angle_degrees, speed_percentage)

  #   # Update LED states based on joystick position.
  #   if (x_value >= 0.0 && x_value <= 0.3) || (x_value >= 0.7 && x_value <= 0.9) do
  #     GPIO.write(led_x_gpio, 1)
  #   else
  #     GPIO.write(led_x_gpio, 0)
  #   end

  #   if (x_value >= 0.4 && x_value <= 0.6) do
  #     GPIO.write(led_y_gpio, 1)
  #   else
  #     GPIO.write(led_y_gpio, 0)
  #   end

  #   # Pause execution for 100 milliseconds before the next iteration.
  #   Process.sleep(100)

  #   # Recursively call the loop function to continue reading and processing joystick values.
  #   loop(x_gpio, y_gpio, led_x_gpio, led_y_gpio)
  # end
end
