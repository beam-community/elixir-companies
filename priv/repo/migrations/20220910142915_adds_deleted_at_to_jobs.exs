defmodule Companies.Repo.Migrations.AddsDeletedAtToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :deleted_at, :utc_datetime
    end
  end
end
