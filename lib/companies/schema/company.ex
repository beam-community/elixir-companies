defmodule Companies.Schema.Company do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Companies.Schema.{Industry, Job, PendingChange}

  @derive {Phoenix.Param, key: :slug}
  schema "companies" do
    field :blog, :string
    field :description, :string
    field :github, :string
    field :location, :string
    field :name, :string
    field :url, :string
    field :slug, :string

    belongs_to :industry, Industry
    has_many :jobs, Job, defaults: [removed_pending_change_id: nil]
    # Optional reference to the change that removed the resource
    belongs_to :removed_pending_change, PendingChange

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :description, :url, :github, :location, :blog, :industry_id, :slug])
    |> validate_required([:name, :description, :url, :industry_id])
    |> generate_slug()
    |> unique_constraint(:slug, message: "Company slug already exists")
  end

  defp generate_slug(%Ecto.Changeset{data: %{id: id}} = changeset) when not is_nil(id) do
    changeset
  end

  defp generate_slug(%Ecto.Changeset{changes: %{name: name}} = changeset) do
    slug =
      name
      |> String.replace(~r/['’]s/u, "s")
      |> String.downcase()
      |> String.replace(~r/([^a-z0-9가-힣])+/, "-")
      |> String.replace(" ", "-")

    put_change(changeset, :slug, slug)
  end

  defp generate_slug(changeset), do: changeset
end
