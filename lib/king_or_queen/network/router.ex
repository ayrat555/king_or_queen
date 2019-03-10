defmodule KingOrQueen.Network.Router do
  use Plug.Router

  alias Plug.Conn
  alias KingOrQueen.Player

  plug(:match)
  plug(:dispatch)

  get "/choose_card" do
    card_signature = Player.choose_card() |> Base.encode16(case: :lower)

    json_result = Jason.encode!(%{signature: card_signature})

    send_resp(conn, 200, json_result)
  end

  get "/receive_guess" do
    conn = Conn.fetch_query_params(conn)
    signature = conn.params["signature"] |> Base.decode16!(case: :lower)
    guessed_card = conn.params["guessed_card"]

    {:ok, public_key} = Player.public_key(signature, guessed_card) |> ExPublicKey.pem_encode()

    json_result = Jason.encode!(%{public_key: public_key})

    send_resp(conn, 200, json_result)
  end

  get("/check_guess", do: send_resp(conn, 200, "Checking"))

  match(_, do: send_resp(conn, 404, "Oops!"))
end
