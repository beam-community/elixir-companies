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

    test "does not retrieve deleted records" do
      insert(:company, %{deleted_at: DateTime.utc_now()})
      insert(:company)

      assert %{page_number: 1, page_size: 16, total_entries: 1, total_pages: 1} = Companies.all()
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

    test "filters companies by text (by location)" do
      insert(:company, name: "ZULU", location: "Australia")
      insert(:company, name: "BETA", location: "Brazil")
      insert(:company, name: "ALPHA", location: "Australia")

      assert %{entries: [%{name: "ALPHA"}, %{name: "ZULU"}]} = Companies.all(%{"search" => %{"text" => "aust"}})
      assert %{entries: [%{name: "BETA"}]} = Companies.all(%{"search" => %{"text" => "zil"}})
      assert %{entries: []} = Companies.all(%{"search" => %{"text" => "cana"}})
    end

    test "trims leading and trailing whitespace on text search (by location)" do
      insert(:company, name: "ZULU", location: "Canada")
      insert(:company, name: "BETA", location: "Brazil")
      insert(:company, name: "ALPHA", location: "Australia")

      assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => "aus "}})
      assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => " australia"}})
      assert %{entries: [%{name: "ALPHA"}]} = Companies.all(%{"search" => %{"text" => " lia "}})
    end

    test "filters companies by text (by name and location)" do
      insert(:company, name: "AUSTO", location: "Canada")
      insert(:company, name: "ALPHA", location: "Australia")

      assert %{entries: [%{name: "ALPHA"}, %{name: "AUSTO"}]} = Companies.all(%{"search" => %{"text" => "aust"}})
    end

    test "trims leading and trailing whitespace on text search (by name and location)" do
      insert(:company, name: "AUSTO", location: "Canada")
      insert(:company, name: "ALPHA", location: "Australia")

      assert %{entries: [%{name: "ALPHA"}, %{name: "AUSTO"}]} = Companies.all(%{"search" => %{"text" => "aust "}})
      assert %{entries: [%{name: "ALPHA"}, %{name: "AUSTO"}]} = Companies.all(%{"search" => %{"text" => " aust"}})
      assert %{entries: [%{name: "ALPHA"}, %{name: "AUSTO"}]} = Companies.all(%{"search" => %{"text" => " aust "}})
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

  describe "get!/1" do
    test "retrieves by id" do
      %{id: company_id} = insert(:company)

      assert %{id: ^company_id} = Companies.get!(company_id)
    end

    test "does not retrieve deleted record" do
      company = insert(:company, %{deleted_at: DateTime.utc_now()})

      assert_raise Ecto.NoResultsError, fn -> Companies.get!(company.id) end
    end
  end

  describe "count/0" do
    test "calculates non-deleted companies" do
      insert_list(2, :company)
      insert(:company, %{deleted_at: DateTime.utc_now()})

      assert 2 == Companies.count()
    end
  end

  describe "create/2" do
    test "creates a company" do
      assert {:ok, %{}} =
               :company
               |> params_for()
               |> Companies.create()
    end

    test "returns an error for invalid changes" do
      assert {:error, _changeset} = Companies.create(%{name: "invalid"})
    end
  end

  describe "delete/2" do
    test "soft deletes an existing company" do
      assert {:ok, %{deleted_at: dt}} =
               :company
               |> insert()
               |> Companies.delete()

      refute is_nil(dt)
    end
  end

  describe "update/3" do
    test "creates a pending change for company updates when changes are valid" do
      assert {:ok, %{}} =
               :company
               |> insert()
               |> Companies.update(%{name: "updated"})
    end

    test "returns an error for invalid changes" do
      assert {:error, _changeset} =
               :company
               |> insert()
               |> Companies.update(%{name: nil})
    end
  end

  describe "change/1" do
    test "creates a changeset for company details" do
      company = insert(:company)
      assert %Ecto.Changeset{data: ^company} = Companies.change(company)
    end
  end
end
