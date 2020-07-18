defmodule ProtectedHelloWeb.Api.UsersController do
  use ProtectedHelloWeb, :controller
	
	def create(conn, params) do
		conn 
		|> put_resp_header("Content-Type", "application/json") 
		|> send_resp(200, %{message: "Create called"} |> Jason.encode!)
	end

	def update(conn, params) do
		conn 
		|> put_resp_header("Content-Type", "application/json") 
		|> send_resp(200, %{message: "Update called"} |> Jason.encode!)
	end
	
	def show(conn, params) do
		conn 
		|> put_resp_header("Content-Type", "application/json") 
		|> send_resp(200, %{message: "Show called"} |> Jason.encode!)
	end
	
	def delete(conn, params) do
		conn 
		|> put_resp_header("Content-Type", "application/json") 
		|> send_resp(200, %{message: "Delete called"} |> Jason.encode!)
	end

end