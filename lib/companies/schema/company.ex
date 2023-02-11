defmodule Companies.Schema.Company do
  @moduledoc false

  # @enforce_keys [:industries, :last_changed_on, :location, :name, :website]

  defstruct [
    :blog,
    :description,
    :github,
    :id,
    :industries,
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
