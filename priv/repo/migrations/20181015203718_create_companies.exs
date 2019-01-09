defmodule Companies.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :description, :string
      add :url, :string
      add :github, :string
      add :location, :string
      add :blog, :string
      add :industry_id, references(:industries, on_delete: :nothing)

      timestamps()
    end

    create index(:companies, [:industry_id])
  end
end
