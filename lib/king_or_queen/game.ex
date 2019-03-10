defmodule KingOrQueen.Game do
  alias KingOrQueen.Player
  alias Mix.Shell.IO, as: ShellIO

  @request_params [timeout: 50_000, recv_timeout: 50_000]

  def start(alice_address) do
    case HTTPoison.get("#{alice_address}/choose_card", [], @request_params) do
      {:ok, response} ->
        hex_signature = Jason.decode!(response.body)["signature"]
        signature = Base.decode16!(hex_signature, case: :lower)
        {_signature, guessed_card} = Player.guess_card(signature)

        case HTTPoison.get(
               "#{alice_address}/receive_guess",
               [],
               Keyword.put(@request_params, :params, %{
                 signature: hex_signature,
                 guessed_card: guessed_card
               })
             ) do
          {:ok, response} ->
            {:ok, public_key} = Jason.decode!(response.body)["public_key"] |> ExPublicKey.loads()

            if Player.check_guess(signature, public_key) do
              ShellIO.info("You won")
            else
              ShellIO.info("You lost")
            end

            if ShellIO.yes?("Play again?") do
              start(alice_address)
            end

          _ ->
            ShellIO.info("Alic is offline")
        end

      _ ->
        ShellIO.info("Alic is offline")
    end
  end
end
