defmodule Companies.Schema.Industry do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Companies.Schema.Company

  schema "industries" do
    field :name, :string
    field :deleted_at, :utc_datetime

    has_many :companies, Company

    timestamps()
  end

  @doc false
  def changeset(industry, attrs) do
    industry
    |> cast(attrs, [:name, :deleted_at])
    |> validate_required([:name])
  end
end
