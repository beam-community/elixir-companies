defmodule Companies.Companies do
  @moduledoc """
  """

  import Ecto.Query, warn: false

  alias Companies.{PendingChanges, Repo}
  alias Companies.Schema.Company

  @doc """
  Returns the list of paginated companies.

  ## Examples

  iex> all()
  [%Company{}, ...]

  """

  def all(params \\ %{}) do
    page = Map.get(params, "page", "1")

    (c in Company)
    |> from()
    |> join(:inner, [c], i in assoc(c, :industry))
    |> join(:left, [c, _i], j in assoc(c, :jobs))
    |> distinct([c, _i, _j], c)
    |> predicates(params)
    |> preload([_c, i, j], industry: i, jobs: j)
    |> Repo.paginate(page: page, page_size: 8)
  end

  @doc """
  Returns the total company count

  ## Examples

  iex> count()
  23

  """
  def count do
    query = from c in Company, select: count(c.id)

    Repo.one(query)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

  iex> get!(123)
  %Company{}

  iex> get!(456)
  ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Company, id)

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

  iex> update(company, %{field: new_value})
  {:ok, %Company{}}

  iex> update(company, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update(%Company{} = company, attrs, user) do
    company
    |> Company.changeset(attrs)
    |> PendingChanges.create(:update, user)
  end

  @doc """
  Deletes a Company.

  ## Examples

  iex> delete(company)
  {:ok, %Company{}}

  iex> delete(company)
  {:error, %Ecto.Changeset{}}

  """
  def delete(%Company{} = company, user) do
    PendingChanges.create(company, :delete, user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

  iex> change(company)
  %Ecto.Changeset{source: %Company{}}

  """
  def change(%Company{} = company) do
    Company.changeset(company, %{})
  end

  defp predicates(query, %{"type" => <<start, finish>>}) when start in 97..122 do
    query = order_by(query, [c, _i, _j], asc: fragment("LOWER(?)", c.name))

    Enum.reduce(start..finish, query, fn char, acc ->
      or_where(acc, [c], ilike(c.name, ^"#{[char]}%"))
    end)
  end

  defp predicates(query, %{"type" => "hiring"}) do
    query
    |> exclude(:left_join)
    |> join(:inner, [c, _i, _j], j in assoc(c, :jobs))
    |> order_by([_c, _i, j], desc: j.inserted_at)
  end

  defp predicates(query, _) do
    order_by(query, [c, _i, _j], desc: c.inserted_at)
  end
end
