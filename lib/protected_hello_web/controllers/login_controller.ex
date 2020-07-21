defmodule ProtectedHelloWeb.Api.LoginController do
  use ProtectedHelloWeb, :controller

  alias ProtectedHelloWeb.UserStore

  def sign_in(conn, params) do
    # Find the user in the database based on the credentials sent with the request
    with %ProtectedHelloWeb.Models.User{} = user <- UserStore.get_user_by_id(params["email"]) do
      # Attempt to authenticate the user
      with {:ok, token, _claims} <- authenticate(%{user: user, password: params["password"]}) do
        # Render the token
        conn
        |> send_resp(200, %{ultimate_token_aka_token_of_all_tokens: token} |> Jason.encode!())
      end
    end
  end

  defp authenticate(%{user: user = %{password: password}, password: password}) do
    # defp authenticate(%{user: user, password: password}) when user.password == password do
    # Does password match the one stored in the database?
    # case Comeonin.Bcrypt.checkpw(password, user.password_digest) do
    #   true ->
    #     # Yes, create and return the token
    ProtectedHelloWeb.Guardian.encode_and_sign(user, %{
      "resource_access" => %{
        "phoenix-demo" => %{
          "roles" => ["admin", "users"]
        }
      }
    })

    # _ ->
    # No, return an error
    # end
  end

  defp authenticate(_) do
    {:error, :unauthorized}
  end
end
