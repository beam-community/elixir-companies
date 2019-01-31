defmodule Companies.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false

  alias Companies.{PendingChanges, Repo}
  alias Companies.Schema.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    Company
    |> Repo.all()
    |> Repo.preload([:industry, :jobs])
  end

  def list_recent_companies do
    query =
      from(c in Company,
        order_by: [desc: c.inserted_at],
        limit: 8,
        preload: [:industry, :jobs]
      )

    Repo.all(query)
  end

  def list_hiring_companies do
    query =
      from(c in Company,
        join: j in assoc(c, :jobs),
        order_by: [desc: j.inserted_at],
        preload: [:industry, :jobs]
      )

    Repo.all(query)
  end

  def count_total do
    query = from(c in Company, select: count(c.id))
    Repo.one(query)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Submits a new company for approval.

  ## Examples

      iex> create(%{field: value}, current_user())
      :ok

      iex> create(%{field: bad_value}, current_user())
      {:error, %Ecto.Changeset{}}

  """
  @spec create(map(), map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs, user) do
    %Company{}
    |> Company.changeset(attrs)
    |> PendingChanges.create(:create, user)
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{source: %Company{}}

  """
  def change_company(%Company{} = company) do
    Company.changeset(company, %{})
  end
end
