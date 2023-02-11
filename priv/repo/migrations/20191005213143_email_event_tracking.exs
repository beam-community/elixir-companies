defmodule Companies.Repo.Migrations.EmailEventTracking do
  use Ecto.Migration

  def change do
    create table(:email_events) do
      add(:event, :string, null: false)
      add(:sg_event_id, :string, null: false)
      add(:sg_message_id, :string, null: false)

      add(:user_id, references(:users), null: false)

      timestamps()
    end

    create(unique_index(:email_events, [:sg_event_id]))
  end
end
