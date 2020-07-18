defmodule ProtectedHelloWeb.Router do
  use ProtectedHelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug ProtectedHelloWeb.Auth.Pipeline
  end

  scope "/api", ProtectedHelloWeb.Api do
    pipe_through :api
  
    resources "/users", UsersController, only: [:create]
    get "/dummy/json", DummyController, :get_json
    post "/login/sign_in", LoginController, :sign_in
  end

  scope "/api", ProtectedHelloWeb.Api do
    pipe_through [:api, :api_auth]
  
    resources "/users", UsersController, only: [:update, :show, :delete]
  end

  scope "/", ProtectedHelloWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProtectedHelloWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ProtectedHelloWeb.Telemetry
    end
  end
end
