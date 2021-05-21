defmodule Companies.Companies do
  @moduledoc false

  alias Companies.Company

  @companies (for file <- Path.wildcard("priv/companies/*.exs") do
                {attrs, _bindings} = Code.eval_file(file)
                Companies.Company.build(file, attrs)
              end)

  @by_slug Enum.reduce(@companies, %{}, &Map.put(&2, &1.slug, &1))
  @by_legacy_id @companies |> Enum.reject(&is_nil(&1.old_id)) |> Enum.into(%{}, &{&1.old_id, &1})
  @by_industries Enum.reduce(@companies, %{}, fn company, acc ->
                   Enum.reduce(company.industries, acc, fn industry, acc2 ->
                     Map.update(acc2, industry, [company], &[company | &1])
                   end)
                 end)
  @by_hiring @companies |> Enum.reject(&(length(&1.jobs) == 0)) |> Enum.into([], & &1)

  @doc """
  Returns the list of paginated companies.

  ## Examples

  iex> all()
  [%Company{}, ...]

  """

  def all do
    @companies
  end

  def hiring do
    Enum.shuffle(@by_hiring)
  end

  @doc """
  Returns a list of industries currently assigned to companies
  """
  def industries do
    Map.keys(@by_industries)
  end

  @doc """
  Returns 10 random companies

  ## Examples

  iex> random()
  [%Company{}, ...]

  """
  def random(num \\ 1) do
    :random.seed(:os.timestamp())

    all()
    |> Enum.shuffle()
    |> Enum.take(num)
  end

  @doc """
  Returns the total company count

  ## Examples

  iex> count()
  23

  """
  def count, do: length(all())

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

  iex> get!(123)
  %Company{}

  iex> get!("company")
  %Company{}

  iex> get!(456)
  (Companies.NotFoundError)

  """
  def get!(slug) do
    with nil <- Map.get(@by_slug, slug) do
      raise(Companies.NotFoundError)
    end
  end

  def get_by_legacy_id(id_or_slug) do
    with true <- Regex.match?(~r/\d*/, id_or_slug),
         {id, _} = Integer.parse(id_or_slug),
         %Company{} = company <- Map.get(@by_legacy_id, id) do
      company
    else
      _ -> nil
    end
  end
end
