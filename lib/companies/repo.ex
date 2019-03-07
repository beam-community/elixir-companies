defmodule Companies.Repo do
  use Ecto.Repo,
    otp_app: :companies,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: Application.get_env(:companies, :companies_per_page), max_page_size: 120

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end
end
