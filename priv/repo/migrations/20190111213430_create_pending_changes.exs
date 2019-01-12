defmodule Companies.Repo.Migrations.CreatePendingChanges do
  use Ecto.Migration

  def change do
    create table(:pending_changes) do
      add :action, :string, null: false
      add :approved, :boolean, default: false, null: false
      add :changes, :map, null: false
      add :note, :string, null: false
      add :resource, :string, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end
  end
end
