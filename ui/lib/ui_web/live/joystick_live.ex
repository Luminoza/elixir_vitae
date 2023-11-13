# UiWeb.JoystickLive:
# This module defines a LiveView component for the Joystick Website. It handles the display
# and interaction of a joystick element. The initial mount sets the default position of the
# joystick. The module includes event handlers for updating joystick parameters and rendering
# the current joystick state. Additionally, JavaScript code is provided for handling joystick
# movements on the client side, with WebSocket communication for real-time updates. The joystick
# is visually represented on an HTML canvas, and the module includes functions to calculate and
# display joystick coordinates, speed, and angle. Users can refer to the linked YouTube video for
# further details.

defmodule UiWeb.JoystickLive do
  # Use the UiWeb live view functionality
  use UiWeb, :live_view

  # Initial mount of the live view
  def mount(_params, _session, socket) do
    # Set default joystick position
    {:ok, assign(socket, x: 0.0, y: 0.0, angle: 0, speed: 0)}
  end

  # Event handler for receiving joystick updates
  def handle_info(%{x: x, y: y, angle: angle, speed: speed}, socket) do
    {:noreply, assign(socket, x: x, y: y, angle: angle, speed: speed)}
  end

  # Cast event for updating joystick parameters
  def handle_cast({:update_joystick, x, y, angle, speed}, socket) do
    {:noreply, assign(socket, x: x, y: y, angle: angle, speed: speed)}
  end

  # Rendering the live view
  def render(assigns) do
    ~L"""
    <head>
      <!-- Title of the Joystick Website -->
      <title>The Joystick Website · Antonin TERRASSON</title>
    </head>

    <main class="moitie-ecran" style="margin-top: 5%;">
      <!-- Title and link to the Joystick Website -->
      <h1 class="title">The Joystick Website<a href="https://www.youtube.com/watch?v=y6120QOlsfU&t=0m31s">®</a></h1>

      <!-- Display joystick parameters -->
      <div class="flex items-center justify-between font-semibold leading-6 text-zinc-900 mt-20 p-2 bg-gradient-to-b from-red-300 to-yellow-200 rounded-lg">
        <p>X: <%= @x %></p>
        <p>Y: <%= @y %></p>
        <p>Speed: <%= @speed %>%</p>
        <p>Angle: <%= @angle %></p>
      </div>
    </main>
    """
  end
end

# JavaScript code for handling joystick movements
# <script>
#   // WebSocket connection to Arduino
#   var connection = new WebSocket('ws://' + "192.168.4.1" + ':81/', ['arduino']);
#   connection.onopen = function () {
#       connection.send('Connect ' + new Date());
#   };
#   connection.onerror = function (error) {
#       console.log('WebSocket Error ', error);
#       alert('WebSocket Error ', error);
#   };
#   connection.onmessage = function (e) {
#       console.log('Server: ', e.data);
#   };

#   // Function to send joystick parameters to Arduino
#   function send(x, y, speed, angle) {
#       var data = {"x": x, "y": y, "speed": speed, "angle": angle};
#       data = JSON.stringify(data);
#       console.log(data);
#       connection.send(data);
#   }
# </script>

# JavaScript code for handling joystick movements on HTML canvas
# <script>
#   var canvas, ctx;

#   // Event listeners and initialization on window load
#   window.addEventListener('load', () => {
#       canvas = document.getElementById('canvas');
#       ctx = canvas.getContext('2d');
#       resize();

#       document.addEventListener('mousedown', startDrawing);
#       document.addEventListener('mouseup', stopDrawing);
#       document.addEventListener('mousemove', Draw);

#       document.addEventListener('touchstart', startDrawing);
#       document.addEventListener('touchend', stopDrawing);
#       document.addEventListener('touchcancel', stopDrawing);
#       document.addEventListener('touchmove', Draw);
#       window.addEventListener('resize', resize);

#       document.getElementById("x_coordinate").innerText = 0;
#       document.getElementById("y_coordinate").innerText = 0;
#       document.getElementById("speed").innerText = 0;
#       document.getElementById("angle").innerText = 0;
#   });

#   // Variables for canvas size, joystick radius, and original position
#   var width, height, radius, x_orig, y_orig;

#   // Function to resize canvas and redraw elements
#   function resize() {
#       width = window.innerWidth;
#       radius = 100;
#       height = radius * 6.5;
#       ctx.canvas.width = width;
#       ctx.canvas.height = height;
#       background();
#       joystick(width / 2, height / 3);
#   }

#   // Function to draw background circle
#   function background() {
#       x_orig = width / 2;
#       y_orig = height / 3;
#       ctx.beginPath();
#       ctx.arc(x_orig, y_orig, radius + 20, 0, Math.PI * 2, true);
#       ctx.fillStyle = '#ECE5E5';
#       ctx.fill();
#   }

#   // Function to draw joystick circle
#   function joystick(width, height) {
#       ctx.beginPath();
#       ctx.arc(width, height, radius, 0, Math.PI * 2, true);
#       ctx.fillStyle = '#F08080';
#       ctx.fill();
#       ctx.strokeStyle = '#F6ABAB';
#       ctx.lineWidth = 8;
#       ctx.stroke();
#   }

#   // Variables for joystick coordinates and drawing state
#   let coord = { x: -10, y: 0 };
#   let paint = false;

#   // Function to get mouse or touch position
#   function getPosition(event) {
#       var mouse_x = event.clientX || event.touches[0].clientX;
#       var mouse_y = event.clientY || event.touches[0].clientY;
#       coord.x = mouse_x - canvas.offsetLeft;
#       coord.y = mouse_y - canvas.offsetTop;
#   }

#   // Function to check if the position is inside the joystick circle
#   function is_it_in_the_circle() {
#       var current_radius = Math.sqrt(Math.pow(coord.x - x_orig, 2) + Math.pow(coord.y - y_orig, 2));
#       if (radius >= current_radius) return true;
#       else return false;
#   }

#   // Function to start drawing
#   function startDrawing(event) {
#       paint = true;
#       getPosition(event);
#       if (is_it_in_the_circle()) {
#           ctx.clearRect(0, 0, canvas.width, canvas.height);
#           background();
#           joystick(coord.x, coord.y);
#           Draw();
#       }
#   }

#   // Function to stop drawing
#   function stopDrawing() {
#       paint = false;
#       ctx.clearRect(0, 0, canvas.width, canvas.height);
#       background();
#       joystick(width / 2, height / 3);
#       document.getElementById("x_coordinate").innerText = 0;
#       document.getElementById("y_coordinate").innerText = 0;
#       document.getElementById("speed").innerText = 0;
#       document.getElementById("angle").innerText = 0;
#   }

#   // Function to draw and send joystick parameters
#   function Draw(event) {
#       if (paint) {
#           ctx.clearRect(0, 0, canvas.width, canvas.height);
#           background();
#           var angle_in_degrees, x, y, speed;
#           var angle = Math.atan2((coord.y - y_orig), (coord.x - x_orig));

#           if (Math.sign(angle) == -1) {
#               angle_in_degrees = Math.round(-angle * 180 / Math.PI);
#           }
#           else {
#               angle_in_degrees = Math.round(360 - angle * 180 / Math.PI);
#           }

#           if (is_it_in_the_circle()) {
#               joystick(coord.x, coord.y);
#               x = coord.x;
#               y = coord.y;
#           }
#           else {
#               x = radius * Math.cos(angle) + x_orig;
#               y = radius * Math.sin(angle) + y_orig;
#               joystick(x, y);
#           }

#           getPosition(event);

#           speed = Math.round(100 * Math.sqrt(Math.pow(x - x_orig, 2) + Math.pow(y - y_orig, 2)) / radius);

#           var x_relative = Math.round(x - x_orig);
#           var y_relative = Math.round(y - y_orig);

#           document.getElementById("x_coordinate").innerText = x_relative;
#           document.getElementById("y_coordinate").innerText = y_relative;
#           document.getElementById("speed").innerText = speed;
#           document.getElementById("angle").innerText = angle_in_degrees;

#           send(x_relative, y_relative, speed, angle_in_degrees);
#       }
#   }
# </script>
