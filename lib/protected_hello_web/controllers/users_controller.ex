defmodule ProtectedHelloWeb.Api.UsersController do
  use ProtectedHelloWeb, :controller

  alias ProtectedHelloWeb.Guardian, as: MyGuardian

  # plug Guardian.Permissions, ensure: %{default: [:public_profile], user_actions: [:books]}

  def create(conn, params) do
    conn
    |> put_resp_header("Content-Type", "application/json")
    |> send_resp(200, %{message: "Create called"} |> Jason.encode!())
  end

  def update(conn, params) do
    conn
    |> put_resp_header("Content-Type", "application/json")
    |> send_resp(200, %{message: "Update called"} |> Jason.encode!())
  end

  def show(conn, params) do
    conn
    |> put_resp_header("Content-Type", "application/json")
    |> send_resp(200, %{message: "Show called"} |> Jason.encode!())
  end

  def delete(conn, params) do
    claims = Guardian.Plug.current_claims(conn)
    is_authenticated = "superuser" in claims["resource_access"]["phoenix-demo"]["roles"]

    if is_authenticated do
      conn
      |> put_resp_header("Content-Type", "application/json")
      |> send_resp(200, %{message: "Delete called"} |> Jason.encode!())
    else
      conn
      |> put_resp_header("Content-Type", "text/plain")
      |> send_resp(403, "\"FORBIDDEN\"")
    end
  end
end
