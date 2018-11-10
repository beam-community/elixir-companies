defmodule ElixirCompaniesWeb.Plugs.Menu do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :industries_for_menu, ElixirCompanies.Industries.list_available_industries())
  end
end
