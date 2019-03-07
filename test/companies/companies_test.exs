defmodule Companies.CompaniesTest do
  use Companies.DataCase

  import ExUnit.CaptureLog

  alias Companies.Companies

  setup do
    {:ok, %{user: insert(:user)}}
  end

  describe "all/1" do
    test "retrieves a paginated list of companies" do
      insert_list(2, :company)
      assert %{page_number: 1, page_size: 16, total_entries: 2, total_pages: 1} = Companies.all()
    end

    test "filters companies by hiring" do
      [company, _] = insert_list(2, :company)
      insert(:job, company: company)
      assert %{total_entries: 1} = Companies.all(%{"type" => "hiring"})
    end

    test "filters companies by starting letter" do
      insert(:company, name: "ALPHA")
      insert(:company, name: "ZULU")
      assert %{total_entries: 1} = Companies.all(%{"type" => "ae"})
    end
  end

  describe "create/2" do
    test "creates a pending change for a new company when changes are valid", %{user: user} do
      capture_log(fn ->
        assert {:ok, %{action: "create", resource: "company"}} =
                 :company
                 |> params_for()
                 |> Companies.create(user)
      end)
    end

    test "returns an error for invalid changes", %{user: user} do
      assert {:error, _changeset} = Companies.create(%{name: "invalid"}, user)
    end
  end

  describe "delete/2" do
    test "creates a pending change for deleting a company", %{user: user} do
      capture_log(fn ->
        assert {:ok, %{action: "delete", resource: "company"}} =
                 :company
                 |> insert()
                 |> Companies.delete(user)
      end)
    end
  end

  describe "update/3" do
    test "creates a pending change for company updates when changes are valid", %{user: user} do
      capture_log(fn ->
        assert {:ok, %{action: "update", resource: "company"}} =
                 :company
                 |> insert()
                 |> Companies.update(%{name: "updated"}, user)
      end)
    end

    test "returns an error for invalid changes", %{user: user} do
      assert {:error, _changeset} =
               :company
               |> insert()
               |> Companies.update(%{name: nil}, user)
    end
  end
end
