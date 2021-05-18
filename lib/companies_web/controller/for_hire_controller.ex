defmodule CompaniesWeb.ForHireController do
  use CompaniesWeb, :controller

  alias Companies.ForHires

  def index(conn, _params) do
    render(conn, "index.html", developers: ForHires.all())
  end
end
