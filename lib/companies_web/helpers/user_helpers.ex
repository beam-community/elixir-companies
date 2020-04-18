defmodule CompaniesWeb.UserHelpers do
  @moduledoc false

  def admin_session?(conn) do
    case current_user(conn) do
      %{admin: true} -> true
      _ -> false
    end
  end

  def current_user(conn), do: conn.assigns[:current_user]

  def signed_in?(conn), do: current_user(conn) != nil
end
