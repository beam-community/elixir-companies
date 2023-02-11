defmodule Companies.Repo.Migrations.AddsProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:name, :string)
      add(:image, :string)
      add(:description, :text)
      add(:bio, :text)
      add(:location, :string)
      add(:interests, :text)
      add(:cv_url, :string)
      add(:looking_for_job, :boolean)
    end
  end
end
