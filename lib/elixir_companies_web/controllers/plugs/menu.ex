defmodule CompaniesWeb.Plugs.Menu do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :industries_for_menu, Companies.Industries.list_available_industries())
  end
end
