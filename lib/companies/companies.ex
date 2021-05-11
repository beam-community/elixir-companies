defmodule Companies.Companies do
  @moduledoc false

  use NimblePublisher,
    build: Companies.Company,
    from: "priv/companies/*.md",
    as: :companies,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @by_slug Enum.reduce(@companies, %{}, &(Map.put(&2, &1.slug, &1)))
  @by_legacy_id @companies |> Enum.reject(&is_nil(&1.old_id)) |> Enum.into(%{}, &({&1.old_id, &1}))
  @by_industries Enum.reduce(@companies, %{}, fn company, acc ->
    Enum.reduce(company.industries, acc, fn industry, acc2 ->
      Map.update(acc2, industry, [company], &([company | &1]))
    end)
  end)

  @doc """
  Returns the list of paginated companies.

  ## Examples

  iex> all()
  [%Company{}, ...]

  """

  def all do
    @companies
  end

  @doc """
  Returns 10 random companies

  ## Examples

  iex> random()
  [%Company{}, ...]

  """
  def random do
    @companies
    |> Enum.shuffle()
    |> Enum.random(10)
  end

  @doc """
  Returns the total company count

  ## Examples

  iex> count()
  23

  """
  def count, do: length(@companies)

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

  iex> get!(123)
  %Company{}

  iex> get!("company")
  %Company{}

  iex> get!(456)
  nil

  """
  def get!(id_or_slug) do
    with true <- Regex.match?(~r/\d*/, id_or_slug),
         {id, _} <- Integer.parse(id_or_slug) do
      Map.get(@by_legacy_id, id)
    else
      _ -> Map.get(by_slug, id_or_slug)
    end
  end
end
