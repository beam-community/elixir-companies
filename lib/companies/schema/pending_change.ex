defmodule Companies.Schema.PendingChange do
  use Ecto.Schema

  import Ecto.Changeset

  alias Companies.Schema.User

  schema "pending_changes" do
    field :action, :string
    field :approved, :boolean, default: false
    field :changes, :map
    field :note, :string
    field :resource, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:action, :approved, :changes, :note, :resource, :user_id])
    |> validate_required([:action, :changes, :resource, :user_id, :note])
    |> validate_inclusion(:action, ["create", "update", "delete"])
    |> validate_inclusion(:resource, ["company", "industry", "job"])
    |> assoc_constraint(:user)
  end
end
