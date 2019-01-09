defmodule Companies.Repo do
  use Ecto.Repo,
    otp_app: :elixir_companies,
    adapter: Ecto.Adapters.Postgres
end
