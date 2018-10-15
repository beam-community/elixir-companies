defmodule ElixirCompaniesWeb.PageController do
  use ElixirCompaniesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
