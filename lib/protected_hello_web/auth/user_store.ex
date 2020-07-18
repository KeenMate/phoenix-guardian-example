defmodule ProtectedHelloWeb.UserStore do
	# import ProtectedHelloWeb.Models.User
	
	@users [
		%ProtectedHelloWeb.Models.User{id: 1, first_name: "Ondrej", last_name: "Valenta", email: "ondrej.valenta@keenmate.com", password: "abcd"},
		%ProtectedHelloWeb.Models.User{id: 2, first_name: "Filip", last_name: "Jakab (brzy Valenta)", email: "ondrej.valenta@keenmate.com", password: "bcde"}
	]

	def get_user_by_id(email) do
		@users |> Enum.find(fn x -> x.email == email end)
	end
end