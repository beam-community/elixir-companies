defmodule CompaniesWeb.Plugs.SiteData do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :site_data, Application.get_env(:companies, :site_data))
  end
end
