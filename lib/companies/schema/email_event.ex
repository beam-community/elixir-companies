defmodule Companies.Schema.EmailEvent do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Companies.Schema.User

  schema "email_events" do
    field :event, :string, null: false
    field :sg_event_id, :string, null: false
    field :sg_message_id, :string, null: false

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(email_event, attrs) do
    email_event
    |> cast(attrs, [:event, :sg_event_id, :sg_message_id, :user_id])
    |> validate_required([:event, :sg_event_id, :sg_message_id, :user_id])
    |> unique_constraint(:sg_event_id)
  end
end
