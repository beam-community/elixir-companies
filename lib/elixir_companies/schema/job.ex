defmodule Companies.Schema.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias Companies.Schema.Company

  schema "jobs" do
    field :title, :string
    field :url, :string

    belongs_to :company, Company

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:title, :url, :company_id])
    |> validate_required([:title, :url, :company_id])
  end
end
