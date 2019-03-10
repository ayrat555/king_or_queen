defmodule KingOrQueen.Game do
  alias KingOrQueen.Player

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
              IO.puts("You won")
            else
              IO.puts("You lost")
            end

            if prompt_task("Play again? (y or n)") do
              start(alice_address)
            end

          _ ->
            IO.puts("Alic is offline")
        end

      _ ->
        IO.puts("Alic is offline")
    end
  end

  defp prompt_task(message) do
    task = Task.async(fn -> prompt(message) end)

    Task.await(task, :infinity)
  end

  defp prompt(message) do
    result =
      "#{message}\n"
      |> IO.gets()
      |> String.replace("\n", "")

    if result in ["y", "n"] do
      result == "y"
    else
      prompt(message)
    end
  end
end
