defmodule KingOrQueen.Network.RouterTest do
  use ExUnit.Case
  use Plug.Test

  import ExUnit.CaptureIO

  alias KingOrQueen.Network.Router
  alias KingOrQueen.Player

  @opts Router.init([])

  describe "get '/choose_card'" do
    test "returns generated signature" do
      capture_io([input: "King", capture_prompt: true], fn ->
        conn =
          conn(:get, "/choose_card", "")
          |> Router.call(@opts)

        signature = Jason.decode!(conn.resp_body)["signature"] |> Base.decode16!(case: :lower)

        assert Player.public_key(signature, "King")
      end)
    end
  end

  describe "get '/receive_guess'" do
    capture_io([input: "King", capture_prompt: true], fn ->
      signature = Player.choose_card()

      capture_io([input: "King", capture_prompt: true], fn ->
        {_, guess} = Player.guess_card(signature)

        conn =
          conn(:get, "/receive_guess", %{
            signature: Base.encode16(signature, case: :lower),
            guessed_card: guess
          })
          |> Router.call(@opts)

        {:ok, public_key} = Jason.decode!(conn.resp_body)["public_key"] |> ExPublicKey.loads()

        assert Player.check_guess(signature, public_key)
      end)
    end)
  end
end
