# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_companies,
  ecto_repos: [ElixirCompanies.Repo]

# Configures the endpoint
config :elixir_companies, ElixirCompaniesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cnFp+p3HcWa0ZaS5YhEfuJlU2PIxvUinNThsTSXm4ZE2M7D/zYzpfIJGMVNLHtqv",
  render_errors: [view: ElixirCompaniesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElixirCompanies.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

config :elixir_companies, site_data: %{
  name: "Elixir Companies",
  description: "A curated list of companies using Elixir in production, organized by industry.",
  maintainers: [
    "doompsork",
    "burden",
  ],
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
