defmodule ElixirCompaniesWeb.Plugs.Authorize do
  import Plug.Conn
  alias ElixirCompanies.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_session(:user_id)
    |> assign_user(conn)
  end

  defp assign_user(nil, conn), do: conn
  defp assign_user(user_id, conn) do
    user = Accounts.get_user!(user_id)
    assign(conn, :current_user, user)
  end
end
