defmodule Companies.Repo.Migrations.AddsDeletedAtToCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :deleted_at, :utc_datetime
    end
  end
end
