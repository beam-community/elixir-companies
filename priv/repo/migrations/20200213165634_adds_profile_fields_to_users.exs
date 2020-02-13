defmodule Companies.Repo.Migrations.AddsProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :bio, :text
      add :interests, :text
      add :location, :string
      add :cv_url, :string
      add :looking_for_job, :boolean
    end
  end
end
