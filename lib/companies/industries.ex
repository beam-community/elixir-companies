defmodule Companies.Industries do
  import Ecto.Query, warn: false

  alias Companies.Repo
  alias Companies.Schema.Industry

  @doc """
  Returns the list of industries.

  ## Examples

  iex> all()
  [%Industry{}, ...]

  """

  def all do
    query =
      from i in Industry,
        join: c in assoc(i, :companies),
        select: i,
        distinct: true,
        order_by: i.name

    Repo.all(query)
  end
end
