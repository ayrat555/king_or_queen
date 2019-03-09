defmodule KingOrQueen.CryptoTest do
  use ExUnit.Case

  alias KingOrQueen.Crypto

  test "executes game logic without network when bob guessed right" do
    right_answer = "Queen"
    {signature, _private_key, public_key} = Crypto.sign_message(right_answer)

    guess = "Queen"

    assert Crypto.auth_message(guess, signature, public_key)
  end

  test "executes game logic without network when bob guessed wrong" do
    right_answer = "Queen"
    {signature, _private_key, public_key} = Crypto.sign_message(right_answer)

    guess = "King"

    refute Crypto.auth_message(guess, signature, public_key)
  end
end
