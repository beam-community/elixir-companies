defmodule CompaniesWeb.Plugs.Menu do
  import Plug.Conn

  alias Companies.Industries

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :industries_for_menu, Industries.list_available_industries())
  end
end
