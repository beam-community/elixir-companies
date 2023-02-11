defmodule Companies.Repo.Migrations.RemoveUserBio do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove(:bio)
    end
  end
end
