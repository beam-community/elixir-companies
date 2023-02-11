defmodule Companies.Companies do
  @moduledoc false

  use NimblePublisher,
    as: :companies,
    build: Companies.Schema.Company,
    from: Application.app_dir(:companies, "priv/companies/**/*.exs"),
    highlighters: [],
    parser: Companies.Parser

  alias Companies.Helpers
  alias Companies.Schema.Company

  def companies, do: @companies

  @doc """
  Returns the list of paginated companies.

  ## Examples

  iex> all()
  [%Company{}, ...]

  """

  def all(params \\ %{}) do
    companies()
    |> Helpers.searched_list(params)
    |> Helpers.sorted_list(params)
    |> Helpers.paginated_list(params)
  end

  @doc """
  Simply calls `all/1` with a two level order, so that even in the slight chance we have
  two companies with the exact same time of insertion, they will be ordered with
  id next.
  """
  def recent do
    all()
  end

  @doc """
  Returns the total company count

  ## Examples

  iex> count()
  23

  """
  def count do
    length(companies())
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
  def get!(id, _opts \\ []) do
    Enum.find(companies(), &(&1.id == id))
  end

  def get(id, _opts \\ []) do
    {:ok, %Company{}}
  end
end
