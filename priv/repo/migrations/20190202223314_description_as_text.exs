defmodule Companies.Repo.Migrations.DescriptionAsText do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      modify :description, :text
    end
  end
end
