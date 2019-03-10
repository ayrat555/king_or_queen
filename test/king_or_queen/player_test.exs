defmodule KingOrQueen.PlayerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias KingOrQueen.Player

  test "executes game logic" do
    capture_io([input: "King", capture_prompt: true], fn ->
      # Alice chooses card
      card_signature = Player.choose_card()

      # Bob guesses card
      capture_io([input: "Queen", capture_prompt: true], fn ->
        {^card_signature, _guess} = Player.guess_card(card_signature)
      end)

      # Alice returns public key
      public_key = Player.public_key(card_signature, "Queen")

      # Bob checks result
      refute Player.check_guess(card_signature, public_key)
    end)
  end
end
