defmodule Companies.Repo.Migrations.DropsPendingChanges do
  use Ecto.Migration

  def change do
    drop(table(:pending_changes))
  end
end
