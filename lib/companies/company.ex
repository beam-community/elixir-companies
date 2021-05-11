defmodule Companies.Company do
  @moduledoc false

  @enforce_keys [:blog, :date_added, :industries, :github, :locations, :name, :url]
  defstruct [
    :blog,
    :body,
    :date_added,
    :github,
    :industries,
    :locations,
    :old_id,
    :name,
    :slug,
    :url
  ]

  def build(filename, attrs, body) do
    slug = Path.basename(filename, ".md")
    struct!(__MODULE__, [body: body, slug: slug] ++ Map.to_list(attrs))
  end
end
