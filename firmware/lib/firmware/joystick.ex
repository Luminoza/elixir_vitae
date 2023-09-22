defmodule Firmware.Joystick do
  # use Application
  # alias Circuits.GPIO

  # @x_pin Application.compile_env(:joystick, :x_pin, 13) # broche GPIO pour l'axe X
  # @y_pin Application.compile_env(:joystick, :y_pin, 18) # broche GPIO pour l'axe Y

  # @led_x_pin Application.compile_env(:joystick, :led_x_pin, 10) # broche GPIO pour la led
  # @led_y_pin Application.compile_env(:joystick, :led_y_pin, 9) # broche GPIO pour la led

  # @speed_threshold 50  # Ajustez ce seuil en fonction de vos besoins

  # def start(_type, _args) do

  #   x_gpio = 13 #NON
  #   y_gpio = 18 #NON

  #   Pigpiox.GPIO.set_mode(x_gpio, :input)
  #   Pigpiox.GPIO.set_mode(y_gpio, :input)

  #   {:ok, led_x_gpio} = GPIO.open(@led_x_pin, :output)
  #   {:ok, led_y_gpio} = GPIO.open(@led_y_pin, :output)

  #   spawn(fn -> loop(x_gpio, y_gpio, led_x_gpio, led_y_gpio) end)
  #   {:ok, self()}
  # end

  # defp loop(x_gpio, y_gpio, led_x_gpio, led_y_gpio) do

  #   {:ok, x_value} = Pigpiox.GPIO.read(x_gpio)
  #   {:ok, y_value} = Pigpiox.GPIO.read(y_gpio)

  #   # Calcul de l'angle en radians
  #   angle_radians = :math.atan2(y_value, x_value)
  #   # Calcul de l'angle en degrés
  #   angle_degrees = ((angle_radians * 180) / 3.14)
  #   # Calcul de la vitesse en pourcentage en utilisant la distance euclidienne des valeurs normalisées
  #   distance = :math.sqrt(x_value * x_value + y_value * y_value)
  #   speed_percentage = distance * 100

  #   # Envoyer les données du joystick au GenServer
  #   Ui.Manager.set_joystick(x_value, y_value, angle_degrees, speed_percentage)

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

  #   Process.sleep(100)
  #   loop(x_gpio, y_gpio, led_x_gpio, led_y_gpio)
  # end
end
