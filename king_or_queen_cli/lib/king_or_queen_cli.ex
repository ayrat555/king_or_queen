defmodule KingOrQueenCli do
  alias KingOrQueen.Game

  def main(args \\ []) do
    args
    |> parse_args()
    |> start_player()
  end

  defp parse_args(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [alice: :string])

    opts
  end

  defp start_player(alice: alice_address) do
    Application.ensure_all_started(:hackney)

    Game.start(alice_address)
  end

  defp start_player(_) do
    Application.ensure_all_started(KingOrQueen)

    Process.sleep(:infinity)
  end
end
