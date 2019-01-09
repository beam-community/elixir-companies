defmodule Companies.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add(:title, :string)
      add(:url, :string)
      add(:company_id, references(:companies, on_delete: :delete_all))

      timestamps()
    end

    create(index(:jobs, [:company_id]))
  end
end
