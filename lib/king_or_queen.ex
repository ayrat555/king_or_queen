defmodule KingOrQueen do
  require Logger

  def start(_type, _args) do
    {port, _} = (System.get_env("PORT") || "8080") |> Integer.parse()

    children = [
      {Plug.Cowboy, scheme: :http, plug: KingOrQueen.Network.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: KingOrQueen.Supervisor]

    Logger.info("Starting `King or Queen` application...")

    init_table(:alice_table)
    init_table(:bob_table)

    Supervisor.start_link(children, opts)
  end

  defp init_table(name) do
    :ets.new(name, [
      :set,
      :named_table,
      :public,
      write_concurrency: true
    ])
  end
end
