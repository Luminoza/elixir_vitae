defmodule Firmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: Firmware.Worker.start_link(arg)

        # Ui.Manager,
        Ui.Manager.start_link(0),

        #Start All Projects ->

        # Start Led
        Firmware.Led.start(:normal, []),

        # Start Reverse Led
        Firmware.ReverseLed.start(:normal, []),

        # Start FiniteAutomata
        Firmware.FiniteAutomata.start(:normal, []),

        # Start Tetris
        Firmware.Tetris.start(:normal, []),

        # Start Rainbow LED
        Firmware.RainbowLED.start(:normal, [])

      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:firmware, :target)
  end
end
