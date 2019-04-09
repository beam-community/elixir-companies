defmodule CompaniesWeb.CompanyControllerTest do
  use CompaniesWeb.ConnCase

  test "GET / without locale", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn, 302) == "/en"
  end

  test "GET / with en locale", %{conn: conn} do
    conn = get(conn, "/en")
    assert html_response(conn, 200) =~ "Recent Additions"
  end

  test "GET / with ru locale", %{conn: conn} do
    conn = get(conn, "/ru")
    assert html_response(conn, 200) =~ "Последние добавленные"
  end
end
