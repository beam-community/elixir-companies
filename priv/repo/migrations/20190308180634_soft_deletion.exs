defmodule Companies.Repo.Migrations.SoftDeletion do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add(:removed_pending_change_id, references(:pending_changes))
    end

    create index(:companies, [:removed_pending_change_id])

    alter table(:jobs) do
      add(:removed_pending_change_id, references(:pending_changes))
    end

    create index(:jobs, [:removed_pending_change_id])

    alter table(:industries) do
      add(:removed_pending_change_id, references(:pending_changes))
    end

    create index(:industries, [:removed_pending_change_id])
  end
end
