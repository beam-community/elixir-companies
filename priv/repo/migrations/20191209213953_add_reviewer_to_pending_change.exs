defmodule Companies.Repo.Migrations.AddReviewerToPendingChange do
  use Ecto.Migration

  def change do
    alter table(:pending_changes) do
      add(:reviewer_id, references(:users))
    end
  end
end
