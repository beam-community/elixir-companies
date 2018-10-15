defmodule ElixirCompanies.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset


  schema "companies" do
    field :blog, :string
    field :description, :string
    field :github, :string
    field :location, :string
    field :name, :string
    field :url, :string
    field :industry_id, :id

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :description, :url, :github, :location, :blog])
    |> validate_required([:name, :description, :url, :github, :location, :blog])
  end
end
