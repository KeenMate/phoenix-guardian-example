defmodule ProtectedHelloWeb.Api.DummyController do
  use ProtectedHelloWeb, :controller

  def get_json(conn, _) do
    # json(conn, %{data: conn})
    conn
    |> put_resp_header("Content-Type", "application/json")
    # |> send_resp(200, %{message: "Update called"})
    |> send_resp(200, conn |> inspect())
  end
end
