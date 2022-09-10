defmodule Companies.Repo.Migrations.RemovesRemovedPendingChangeFromJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      remove :removed_pending_change_id
    end
  end
end
