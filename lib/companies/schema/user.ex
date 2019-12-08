defmodule Companies.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :email_notifications, :boolean
    field :nickname, :string
    field :token, :string

    field :maintainer, :boolean, default: false, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :email_notifications, :nickname, :token])
    |> validate_required([:email, :nickname, :token])
  end
end
