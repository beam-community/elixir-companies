use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :companies, CompaniesWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :info

# Configure your database
config :companies, Companies.Repo,
  username: "postgres",
  password: "postgres",
  database: "companies_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :companies, Notify.Mailer, adapter: Bamboo.TestAdapter
