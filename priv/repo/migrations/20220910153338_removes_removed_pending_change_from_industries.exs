defmodule Companies.Repo.Migrations.RemovesRemovedPendingChangeFromIndustries do
  use Ecto.Migration

  def change do
    alter table(:industries) do
      remove :removed_pending_change_id
    end
  end
end
