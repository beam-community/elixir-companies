defmodule ElixirCompanies.Companies do
  @moduledoc false

  use NimblePublisher,
    as: :companies,
    build: ElixirCompanies.Companies.Company,
    from: Application.compile_env!(:companies, :companies_directory),
    highlighters: [],
    parser: ElixirCompanies.Parser

  alias ElixirCompanies.Helpers

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
  def get!(name, _opts \\ []) do
    Enum.find(companies(), &(&1.name == name))
  end
end
