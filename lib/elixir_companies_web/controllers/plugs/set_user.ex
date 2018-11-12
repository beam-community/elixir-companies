defmodule ElixirCompaniesWeb.Plugs.SetUser do
  import Plug.Conn
  alias ElixirCompanies.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    cond do
      user = user_id && Accounts.get_user!(user_id) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end
end
