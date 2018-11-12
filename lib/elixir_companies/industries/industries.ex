defmodule ElixirCompanies.Industries do
  @moduledoc """
  The Industries context.
  """

  import Ecto.Query, warn: false
  alias ElixirCompanies.Repo
  alias ElixirCompanies.Industries.Industry

  @doc """
  Returns the list of industries.

  ## Examples

      iex> list_industries()
      [%Industry{}, ...]

  """
  def list_industries do
    Repo.all(Industry)
  end

  def list_available_industries do
    query = from i in Industry, join: c in assoc(i, :companies)
    Repo.all(query)
  end

  @doc """
  Gets a single industry.

  Raises `Ecto.NoResultsError` if the Industry does not exist.

  ## Examples

      iex> get_industry!(123)
      %Industry{}

      iex> get_industry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_industry!(id), do: Repo.get!(Industry, id)

  def get_industry_with_companies!(id) do
    query =
      from i in Industry,
      left_join: c in assoc(i, :companies),
      left_join: ci in assoc(c, :industry),
      left_join: cj in assoc(c, :jobs),
      where: i.id == ^id,
      preload: [companies: {c, industry: ci, jobs: cj}]

    Repo.one(query)
  end

  @doc """
  Creates a industry.

  ## Examples

      iex> create_industry(%{field: value})
      {:ok, %Industry{}}

      iex> create_industry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_industry(attrs \\ %{}) do
    %Industry{}
    |> Industry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a industry.

  ## Examples

      iex> update_industry(industry, %{field: new_value})
      {:ok, %Industry{}}

      iex> update_industry(industry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_industry(%Industry{} = industry, attrs) do
    industry
    |> Industry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Industry.

  ## Examples

      iex> delete_industry(industry)
      {:ok, %Industry{}}

      iex> delete_industry(industry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_industry(%Industry{} = industry) do
    Repo.delete(industry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking industry changes.

  ## Examples

      iex> change_industry(industry)
      %Ecto.Changeset{source: %Industry{}}

  """
  def change_industry(%Industry{} = industry) do
    Industry.changeset(industry, %{})
  end
end
