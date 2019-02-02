# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :companies,
  ecto_repos: [Companies.Repo]

# Configures the endpoint
config :companies, CompaniesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cnFp+p3HcWa0ZaS5YhEfuJlU2PIxvUinNThsTSXm4ZE2M7D/zYzpfIJGMVNLHtqv",
  render_errors: [view: CompaniesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Companies.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

config :companies,
  site_data: %{
    name: "Elixir Companies",
    description: "A collection of companies using Elixir in production.",
    maintainers: [
      "doomspork",
      "burden",
      "gemantzu"
    ]
  }

config :oauth2,
  serializers: %{
    "application/json" => Jason
  }

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user,user:email,public_repo", send_redirect_uri: false]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
