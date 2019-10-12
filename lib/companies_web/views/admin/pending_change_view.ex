defmodule CompaniesWeb.Admin.PendingChangeView do
  use CompaniesWeb, :view

  def to_json(map) do
    Jason.encode!(map, pretty: true)
  end
end
