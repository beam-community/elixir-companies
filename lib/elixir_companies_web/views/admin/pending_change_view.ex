defmodule ElixirCompaniesWeb.Admin.PendingChangeView do
  use ElixirCompaniesWeb, :view

  def to_json(map) do
    Jason.encode!(map)
  end
end
