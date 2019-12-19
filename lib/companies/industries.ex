defmodule Companies.Industries do
  @moduledoc """
  The Industries context.
  """

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
        where: is_nil(i.removed_pending_change_id),
        order_by: i.name

    Repo.all(query)
  end

  def for_select do
    query =
      from i in Industry,
        order_by: i.name,
        select: {i.name, i.id}

    Repo.all(query)
  end
end
