defmodule Companies.CompaniesTest do
  use Companies.DataCase

  alias Companies.Companies

  @moduletag :capture_log

  setup do
    {:ok, %{user: insert(:user)}}
  end

  describe "all/1" do
    test "retrieves a paginated list of companies sorted by inserted datetime" do
      insert(:company, name: "ZULU")
      insert(:company, name: "ALPHA")

      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 2, total_pages: 1} = Companies.all()
      assert 2 == length(entries)
    end

    test "filters companies by hiring sorted by most recent job" do
      alpha = insert(:company, name: "ALPHA")
      zulu = insert(:company, name: "ZULU")

      insert(:job, company: zulu)
      insert(:job, company: alpha)

      assert %{entries: [%{name: "ALPHA"}, %{name: "ZULU"}]} = Companies.all(%{"type" => "hiring"})
    end

    test "filters and sorts companies by starting letter" do
      insert(:company, name: "ZULU")
      insert(:company, name: "BETA")
      insert(:company, name: "ALPHA")

      assert %{entries: [%{name: "ALPHA"}, %{name: "BETA"}]} = Companies.all(%{"type" => "ae"})
    end
  end

  describe "create/2" do
    test "creates a pending change for a new company when changes are valid", %{user: user} do
      assert {:ok, %{action: "create", resource: "company"}} =
               :company
               |> params_for()
               |> Companies.create(user)
    end

    test "returns an error for invalid changes", %{user: user} do
      assert {:error, _changeset} = Companies.create(%{name: "invalid"}, user)
    end
  end

  describe "delete/2" do
    test "creates a pending change for deleting a company", %{user: user} do
      assert {:ok, %{action: "delete", resource: "company"}} =
               :company
               |> insert()
               |> Companies.delete(user)
    end
  end

  describe "update/3" do
    test "creates a pending change for company updates when changes are valid", %{user: user} do
      assert {:ok, %{action: "update", resource: "company"}} =
               :company
               |> insert()
               |> Companies.update(%{name: "updated"}, user)
    end

    test "returns an error for invalid changes", %{user: user} do
      assert {:error, _changeset} =
               :company
               |> insert()
               |> Companies.update(%{name: nil}, user)
    end
  end
end
