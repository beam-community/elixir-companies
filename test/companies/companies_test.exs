defmodule ElixirCompanies.CompaniesTest do
  use ExUnit.Case

  alias ElixirCompanies.Companies

  @moduletag :capture_log

  describe "all/1" do
    test "retrieves a paginated list of companies sorted by name" do
      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 2, total_pages: 1} = Companies.all()
      assert 2 == length(entries)
      assert [%{name: "ALPHA"}, %{name: "ZULU"}] = entries
    end
  end

  test "filters companies by industry" do
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"industry_id" => alpha.industry_id}})
  end

  test "filters companies by text" do
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => "lp"}})
  end

  test "trims leading and trailing whitespace on text search" do
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => "alpha "}})
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => " alpha"}})
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => " alpha "}})
  end

  test "filters companies by text (by location)" do
    assert %{entries: [%{name: "ALPHA"}, %{name: "ZULU"}]} = Companies.all(%{"search" => %{"text" => "aust"}})
    assert %{entries: [%{name: "BETA"}]} = Companies.all(%{"search" => %{"text" => "zil"}})
    assert %{entries: []} = Companies.all(%{"search" => %{"text" => "cana"}})
  end

  test "trims leading and trailing whitespace on text search (by location)" do
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => "aus "}})
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => " australia"}})
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => " lia "}})
  end

  test "filters companies by text (by name and location)" do
    assert %{entries: [%{name: "ALPHA"}, %{name: "AUSTO"}]} = Companies.all(%{"search" => %{"text" => "aust"}})
  end

  test "trims leading and trailing whitespace on text search (by name and location)" do
    insert(:company, name: "AUSTO", location: "Canada")
    insert(:company, name: "ALPHA", location: "Australia")

    assert %{entries: [%{name: "ALPHA"}, %{name: "AUSTO"}]} = Companies.all(%{"search" => %{"text" => "aust "}})
    assert %{entries: [%{name: "ALPHA"}, %{name: "AUSTO"}]} = Companies.all(%{"search" => %{"text" => " aust"}})
    assert %{entries: [%{name: "ALPHA"}, %{name: "AUSTO"}]} = Companies.all(%{"search" => %{"text" => " aust "}})
  end

  describe "recent/1" do
    test "retrieves a paginated list of companies sorted by inserted datetime (desc)" do
      assert %{entries: entries} = Companies.recent()
      assert [%{name: "ALPHA"}, %{name: "ZULU"}] = entries
    end
  end

  describe "get!/1" do
    test "retrieves by id" do
      assert %{name: "ZULU"} = Companies.get!("zulu")
    end
  end

  describe "count/0" do
    test "calculates non-deleted companies" do
      assert 2 == Companies.count()
    end
  end
end
