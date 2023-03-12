defmodule ElixirCompanies.Companies.Company do
  @moduledoc false

  defstruct [
    :blog,
    :description,
    :github,
    :id,
    :industry,
    :jobs,
    :last_changed_on,
    :location,
    :name,
    :website
  ]

  def build(_filename, attrs, _body) do
    struct!(__MODULE__, Map.to_list(attrs))
  end
end
