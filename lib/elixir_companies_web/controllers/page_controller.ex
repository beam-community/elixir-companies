defmodule CompaniesWeb.PageController do
  use CompaniesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
