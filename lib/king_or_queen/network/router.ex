defmodule KingOrQueen.Network.Router do
  use Plug.Router

  alias KingOrQueen.Player

  plug(:match)
  plug(:dispatch)

  get("/choose_card", do: send_resp(conn, 200, Player.choose_card()))
  get("/check_guess", do: send_resp(conn, 200, "Checking"))

  match(_, do: send_resp(conn, 404, "Oops!"))
end
