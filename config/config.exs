# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :protected_hello, ProtectedHelloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "O54H3eYCKEQh2EgLzPjI3/eidPtMOiZnGU6htbWcStd3Jf45btRP2Iee0xVZM2G4",
  render_errors: [view: ProtectedHelloWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ProtectedHello.PubSub,
  live_view: [signing_salt: "W7eE3Jg4"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :protected_hello, ProtectedHelloWeb.Guardian,
       issuer: "protected_hello",
       secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
