defmodule Companies.Repo.Migrations.AddRemoteToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add(:remote, :boolean, default: false)
    end
  end
end
