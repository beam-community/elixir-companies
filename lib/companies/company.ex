defmodule Companies.Company do
  @moduledoc false

  defstruct [
    :blog,
    :description,
    :date_added,
    :github,
    :industries,
    :old_id,
    :name,
    :slug,
    :url,
    jobs: [],
    locations: []
  ]

  def build(filename, attrs) do
    slug = Path.basename(filename, ".exs")
    struct!(__MODULE__, Map.put(attrs, :slug, slug))
  end
end
