defmodule Companies.Schema.Company do
  use Ecto.Schema
  import Ecto.Changeset

  alias Companies.Schema.{Industry, Job}

  schema "companies" do
    field(:blog, :string)
    field(:description, :string)
    field(:github, :string)
    field(:location, :string)
    field(:name, :string)
    field(:url, :string)

    belongs_to(:industry, Industry)
    has_many(:jobs, Job)

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :description, :url, :github, :location, :blog, :industry_id])
    |> validate_required([:name, :description, :url, :industry_id])
  end
end
