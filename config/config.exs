# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sentimeter,
  ecto_repos: [Sentimeter.Repo]

# Configures the endpoint
config :sentimeter, SentimeterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iiZik3A9+l4tlSXGoNZf6QDADWLmVqQrtVmGdqf81AB70XojfMW9xl7p8VWRKGnH",
  render_errors: [view: SentimeterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sentimeter.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "dK9T8MpTkD8zearGN8YVTKyh5eIw7J1HuFXxY7W9W5v6ceq/0keDl7PH1wBxMsSK"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix & Bamboo
config :phoenix, :json_library, Jason
config :bamboo, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
