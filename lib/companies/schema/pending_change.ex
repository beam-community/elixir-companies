defmodule Companies.Schema.PendingChange do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Companies.Schema.User

  schema "pending_changes" do
    field :action, :string
    field :approved, :boolean
    field :changes, :map
    field :note, :string
    field :resource, :string

    field :original, :map, virtual: true

    belongs_to :user, User
    belongs_to :reviewer, User

    timestamps()
  end

  @doc false
  def changeset(pending_change, attrs) do
    pending_change
    |> cast(attrs, [:action, :changes, :resource, :user_id])
    |> validate_required([:action, :changes, :resource, :user_id])
    |> validate_inclusion(:action, ["create", "update", "delete"])
    |> validate_inclusion(:resource, ["company", "industry", "job"])
    |> assoc_constraint(:user)
  end

  def approve_changeset(pending_change, attrs) do
    pending_change
    |> cast(attrs, [:approved, :note, :reviewer_id])
    |> validate_required([:approved, :note, :reviewer_id])
    |> assoc_constraint(:reviewer)
  end
end
