defmodule CompaniesWeb.UserHelpers do
  @moduledoc false

  def current_user(conn), do: get_in(conn, [:assigns, :current_user])
end
