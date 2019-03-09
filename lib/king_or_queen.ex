defmodule KingOrQueen do
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: KingOrQueen.Network.Router, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: KingOrQueen.Supervisor]

    Logger.info("Starting `King or Queen` application...")

    Supervisor.start_link(children, opts)
  end
end
