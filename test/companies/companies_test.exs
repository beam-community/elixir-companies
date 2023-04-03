defmodule Companies.CompaniesTest do
  use ExUnit.Case

  alias Companies.Companies

  @moduletag :capture_log

  describe "all/1" do
    test "retrieves a paginated list of companies sorted by name" do
      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 2, total_pages: 1} = Companies.all()
      assert 2 == length(entries)
      assert [%{name: "ALPHA"}, %{name: "ZULU"}] = entries
    end
  end

  describe "recent/1" do
    test "retrieves a paginated list of companies sorted by inserted datetime (desc)" do
      assert %{entries: entries} = Companies.recent()
      assert [%{name: "ZULU"}, %{name: "ALPHA"}] = entries
    end
  end

  describe "get!/1" do
    test "retrieves by id" do
      assert %{name: "ZULU"} = Companies.get!("zulu")
    end

    test "returns nil if company is missing" do
      refute Companies.get!("beta")
    end
  end

  describe "count/0" do
    test "calculates non-deleted companies" do
      assert 2 == Companies.count()
    end
  end
end
