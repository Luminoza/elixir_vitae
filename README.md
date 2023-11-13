## Antonin TERRASSON - Intership 24 July to 17 november 2023.

 # ESEO, Angers, FRANCE x University of Malta, Msida MSD 2080, MALTA.

The “Elixir Vitae” software is divided into two parts.


# 1 - Firmware

  Allows you to sart a nerves application controlling a Raspberry Pi.
  Different modules are implemented to control different components:
   - LED
   - Buttons
   - Joystick

  ## Targets

  Nerves applications produce images for hardware targets based on the
  `MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
  image that runs on the host (e.g., your laptop). This is useful for executing
  logic tests, running utilities, and debugging. Other targets are represented by
  a short name like `rpi3` that maps to a Nerves system image for that platform.
  All of this logic is in the generated `mix.exs` and may be customized. For more
  information about targets see:

  https://hexdocs.pm/nerves/targets.html#content

  ## Getting Started

  To start your Nerves app:
    * `cd /elixir_vitae/firmware`
    * `export MIX_TARGET=my_target` or prefix every command with
      `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
    * Install dependencies with `mix deps.get`
    * Create firmware with `mix firmware`
    * Burn to an SD card with `mix burn`

  ## Learn more

    * Official docs: https://hexdocs.pm/nerves/getting-started.html
    * Official website: https://nerves-project.org/
    * Forum: https://elixirforum.com/c/nerves-forum
    * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
    * Source: https://github.com/nerves-project/nerves


  # 2 - Ui, Web Site

    Allows you to create a website, integrated into the Nerves application.
    Allows you to interact with the electronic components of the Raspberry Pi

    Incorporates the Tetris game fully coded in Elixir which allows you to play in different ways:
     - The “game controller” made up of the Raspberry Pi card and its components. Allowing you to play remotely, without cables.
     - A computer connected to the web page and the keys on its keyboard.
     - A phone or touch device connected to the web page, directly with your finger.

    ## Getting Started

    To start your Phoenix server alone :
      * `cd /elixir_vitae/ui`
      * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

    Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

    Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


## Thank you and good luck, Antonin TERRASSON on November 13, 2023.
