defmodule Companies.Schema.Company do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Companies.Industries

  schema "companies" do
    field :blog, :string
    field :description, :string
    field :github, :string
    field :industry, :string
    field :jobs, {:array, :string}
    field :last_changed_on, :date
    field :location, :map
    field :name, :string
    field :website, :string

    timestamps()
  end

  def build(_filename, attrs, _body) do
    struct!(__MODULE__, Map.to_list(attrs))
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :website, :github, :industry, :location, :description, :last_changed_on])
    |> validate_required([:name, :website, :industry, :location, :description, :last_changed_on])
    |> validate_inclusion(:industry, Industries.all())
  end
end
