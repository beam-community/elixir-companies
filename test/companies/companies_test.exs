defmodule Companies.CompaniesTest do
  use Companies.DataCase

  alias Companies.Companies

  @moduletag :capture_log

  setup do
    {:ok, %{user: insert(:user)}}
  end

  describe "all/1" do
    test "retrieves a paginated list of companies sorted by name" do
      insert(:company, name: "ALPHA")
      insert(:company, name: "ZULU")

      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 2, total_pages: 1} = Companies.all()
      assert 2 == length(entries)
      assert [%{name: "ALPHA"}, %{name: "ZULU"}] = entries
    end

    test "filters companies by industry" do
      alpha = insert(:company, name: "ALPHA")
      zulu = insert(:company, name: "ZULU")

      insert(:job, company: zulu)
      insert(:job, company: alpha)

      assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"industry_id" => alpha.industry_id}})
    end

    test "filters companies by text" do
      insert(:company, name: "ZULU")
      insert(:company, name: "BETA")
      insert(:company, name: "ALPHA")

      assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => "lp"}})
    end

    test "trims leading and trailing whitespace on text search" do
      insert(:company, name: "ZULU")
      insert(:company, name: "BETA")
      insert(:company, name: "ALPHA")

      assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => "alpha "}})
      assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => " alpha"}})
      assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => " alpha "}})
    end
  end

  describe "recent/1" do
    test "retrieves a paginated list of companies sorted by inserted datetime (desc)" do
      insert(:company, name: "ZULU")
      insert(:company, name: "ALPHA")

      assert %{entries: entries} = Companies.recent()
      assert [%{name: "ALPHA"}, %{name: "ZULU"}] = entries
    end
  end

  describe "get!/2" do
    test "retrieves a company by id" do
      %{id: id} = insert(:company, name: "ZULU")

      assert %{id: ^id} = Companies.get!(id)
    end

    test "preloads given associations" do
      company = insert(:company, name: "ZULU")

      assert %{jobs: []} = Companies.get!(company.id, preloads: [:jobs])
    end

    test "raises for unknown id" do
      assert_raise Ecto.NoResultsError, fn ->
        Companies.get!(1000, preloads: [:jobs])
      end
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
