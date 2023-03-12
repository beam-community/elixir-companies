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
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{industry: "Software"})
  end

  test "filters companies by text" do
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{text: "lp"})
  end

  test "filters companies by text (by location)" do
    assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{text: "GA"})
    assert %{entries: [%{name: "ZULU"}]} = Companies.all(%{text: "San"})
    assert %{entries: []} = Companies.all(%{text: "cana"})
  end

  test "filters companies by text (by name and location)" do
    assert %{entries: [%{name: "ALPHA"}, %{name: "ZULU"}]} = Companies.all(%{text: "a"})
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
