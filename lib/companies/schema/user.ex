defmodule Companies.Schema.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :email_notifications, :boolean
    field :name, :string
    field :nickname, :string
    field :token, :string
    field :bio, :string
    field :interests, :string
    field :location, :string
    field :cv_url, :string
    field :looking_for_job, :boolean

    field :maintainer, :boolean, default: false, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :email_notifications, :nickname, :token, :name])
    |> validate_required([:email, :nickname, :token])
  end

  def profile_changeset(user, attrs) do
    user
    |> cast(attrs, [:bio, :interests, :location, :cv_url, :looking_for_job])
  end
end
