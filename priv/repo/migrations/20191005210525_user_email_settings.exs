defmodule Companies.Repo.Migrations.UserEmailSettings do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email_notifications, :boolean, default: true
    end
  end
end
