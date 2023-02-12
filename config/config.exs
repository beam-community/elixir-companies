# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :companies, CompaniesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cnFp+p3HcWa0ZaS5YhEfuJlU2PIxvUinNThsTSXm4ZE2M7D/zYzpfIJGMVNLHtqv",
  render_errors: [view: CompaniesWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Companies.PubSub,
  live_view: [signing_salt: "IJL0bF+zIE2Ax4MFSi16HqrurNFhiYlD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

config :companies,
  site_data: %{
    name: "Elixir Companies"
  },
  companies_directory: "./priv/companies/**/*.exs"

config :phoenix, :template_engines,
  eex: Appsignal.Phoenix.Template.EExEngine,
  exs: Appsignal.Phoenix.Template.ExsEngine

config :live_dashboard_history, LiveDashboardHistory,
  router: CompaniesWeb.Router,
  metrics: CompaniesWeb.Telemetry,
  buffer_size: 500

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
