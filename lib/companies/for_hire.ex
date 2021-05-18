defmodule Companies.ForHire do
  @moduledoc false

  defstruct [
    :available_for,
    :email,
    :github,
    :location,
    :name,
    :slug
  ]

  def build(filename, attrs) do
    slug = Path.basename(filename, ".exs")
    struct!(__MODULE__, Map.put(attrs, :slug, slug))
  end
end
