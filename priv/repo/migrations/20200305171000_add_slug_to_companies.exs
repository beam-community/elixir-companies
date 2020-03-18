defmodule Companies.Repo.Migrations.AddSlugToCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :slug, :string
    end

    create unique_index(:companies, [:slug])
  end
end
