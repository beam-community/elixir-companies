defmodule Companies.Repo.Migrations.RemovesRemovedPendingChangeFromCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      remove :removed_pending_change_id
    end
  end
end
