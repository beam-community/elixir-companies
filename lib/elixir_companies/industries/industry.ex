defmodule ElixirCompanies.Industries.Industry do
  use Ecto.Schema
  import Ecto.Changeset


  schema "industries" do
    field :name, :string
    has_many :companies, ElixirCompanies.Companies.Company

    timestamps()
  end

  @doc false
  def changeset(industry, attrs) do
    industry
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
