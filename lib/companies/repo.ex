defmodule Companies.Repo do
  use Ecto.Repo,
    otp_app: :companies,
    adapter: Ecto.Adapters.Postgres
end
