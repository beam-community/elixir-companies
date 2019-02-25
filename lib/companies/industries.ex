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
        order_by: i.name

    Repo.all(query)
  end
end
