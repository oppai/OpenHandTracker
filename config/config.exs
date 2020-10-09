# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :open_hand_tracker,
  ecto_repos: [OpenHandTracker.Repo]

# Configures the endpoint
config :open_hand_tracker, OpenHandTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J2EwGte54EAB1irCzvGvvNmhUeU0MRBAC66vAgk/glik0e7QtxlY8HBF5PPDoJSL",
  render_errors: [view: OpenHandTrackerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: OpenHandTracker.PubSub,
  live_view: [signing_salt: "Zhbf8r1t"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
