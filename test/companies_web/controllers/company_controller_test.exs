defmodule CompaniesWeb.CompanyControllerTest do
  use CompaniesWeb.ConnCase

  @moduletag capture_log: true

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

  test "GET /en/companies with industry or search term set", %{conn: conn} do
    industry = insert(:industry)

    insert_list(17, :company, %{industry: industry, name: "Test name"})

    resp = get(conn, "/en/companies?search[industry_id]=1&search[text]=Test&other=parameter") |> html_response(200)
    next_page_link = resp |> Floki.find(".pagination a[rel=next]") |> List.first() |> Floki.attribute("href")

    assert next_page_link == ["?search[industry_id]=1&search[text]=Test&page=2"]
  end
end
