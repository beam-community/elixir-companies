defmodule Companies.Repo.Migrations.AllowNilApprovalStatus do
  use Ecto.Migration

  def change do
    alter table(:pending_changes) do
      modify :approved, :boolean, default: nil, null: true
    end
  end
end
