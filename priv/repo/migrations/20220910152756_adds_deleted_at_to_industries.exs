defmodule Companies.Repo.Migrations.AddsDeletedAtToIndustries do
  use Ecto.Migration

  def change do
    alter table(:industries) do
      add :deleted_at, :utc_datetime
    end
  end
end
