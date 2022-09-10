defmodule Companies.Schema.Job do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Companies.Schema.Company

  schema "jobs" do
    field :title, :string
    field :url, :string
    field :remote, :boolean
    field :expired, :boolean
    field :deleted_at, :utc_datetime

    belongs_to :company, Company

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:title, :url, :company_id, :remote, :expired, :deleted_at])
    |> validate_required([:title, :url, :company_id, :remote])
  end
end
