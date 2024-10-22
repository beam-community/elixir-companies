defmodule Companies.Schema.Company do
  @moduledoc false
  alias Companies.Industries

  # @enforce_keys [:industry, :last_changed_on, :location, :name, :website]

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

  def validate_industries(%{industry: industry} = _attrs) do
    Enum.member?(Industries.all(), industry)
  end
end
