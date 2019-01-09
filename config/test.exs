use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_companies, CompaniesWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :elixir_companies, Companies.Repo,
  username: "postgres",
  password: "postgres",
  database: "elixir_companies_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
