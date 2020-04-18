defmodule Companies.Schema.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :admin,
             :email,
             :email_notifications,
             :token,
             :nickname,
             :name,
             :image,
             :description,
             :bio,
             :location,
             :interests,
             :cv_url,
             :looking_for_job
           ]}
  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :email_notifications, :boolean
    field :token, :string
    field :nickname, :string
    field :name, :string
    field :image, :string
    field :description, :string
    field :bio, :string
    field :location, :string
    field :interests, :string
    field :cv_url, :string
    field :looking_for_job, :boolean

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :email_notifications, :nickname, :token, :name, :image, :description, :bio, :location])
    |> validate_required([:email, :nickname, :token])
  end

  def profile_changeset(user, attrs) do
    cast(user, attrs, [:interests, :cv_url, :looking_for_job])
  end
end
