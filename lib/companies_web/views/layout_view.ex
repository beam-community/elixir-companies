defmodule CompaniesWeb.LayoutView do
  use CompaniesWeb, :view

  def signed_in?(conn) do
    with %{id: _id} <- Map.get(conn.assigns, :current_user) do
      true
    else
      _ -> false
    end
  end
end
