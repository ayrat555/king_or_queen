defmodule Mix.Tasks.Game do
  use Mix.Task

  alias KingOrQueen.Game

  @shortdoc "runs 'King or Queen` game"
  def run(_) do
    Application.ensure_all_started(:hackney)

    Game.start("http://localhost:8090")
  end
end
