defmodule ElixirCompaniesWeb.IndustryControllerTest do
  use ElixirCompaniesWeb.ConnCase

  alias ElixirCompanies.Industries

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:industry) do
    {:ok, industry} = Industries.create_industry(@create_attrs)
    industry
  end

  describe "index" do
    test "lists all industries", %{conn: conn} do
      conn = get(conn, Routes.industry_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Industries"
    end
  end

  describe "new industry" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.industry_path(conn, :new))
      assert html_response(conn, 200) =~ "New Industry"
    end
  end

  describe "create industry" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.industry_path(conn, :create), industry: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.industry_path(conn, :show, id)

      conn = get(conn, Routes.industry_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Industry"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.industry_path(conn, :create), industry: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Industry"
    end
  end

  describe "edit industry" do
    setup [:create_industry]

    test "renders form for editing chosen industry", %{conn: conn, industry: industry} do
      conn = get(conn, Routes.industry_path(conn, :edit, industry))
      assert html_response(conn, 200) =~ "Edit Industry"
    end
  end

  describe "update industry" do
    setup [:create_industry]

    test "redirects when data is valid", %{conn: conn, industry: industry} do
      conn = put(conn, Routes.industry_path(conn, :update, industry), industry: @update_attrs)
      assert redirected_to(conn) == Routes.industry_path(conn, :show, industry)

      conn = get(conn, Routes.industry_path(conn, :show, industry))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, industry: industry} do
      conn = put(conn, Routes.industry_path(conn, :update, industry), industry: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Industry"
    end
  end

  describe "delete industry" do
    setup [:create_industry]

    test "deletes chosen industry", %{conn: conn, industry: industry} do
      conn = delete(conn, Routes.industry_path(conn, :delete, industry))
      assert redirected_to(conn) == Routes.industry_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.industry_path(conn, :show, industry))
      end
    end
  end

  defp create_industry(_) do
    industry = fixture(:industry)
    {:ok, industry: industry}
  end
end
