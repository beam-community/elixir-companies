defmodule Companies.Repo.Migrations.AddsExpiredToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add(:expired, :boolean, default: false)
    end
  end
end
