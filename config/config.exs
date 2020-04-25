# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :malarkey,
  ecto_repos: [Malarkey.Repo]

# Configures the endpoint
config :malarkey, MalarkeyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x1z+IYVV7KnglnWDWY3w2Rnlb8AmGiFG4jHlHmPdOnZK34B5jSDHf7rBvlWB0gjA",
  render_errors: [view: MalarkeyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Malarkey.PubSub,
  live_view: [signing_salt: "UxZ4gU0O"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :malarkey, :pow,
  user: Malarkey.Users.User,
  repo: Malarkey.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
