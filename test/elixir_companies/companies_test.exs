defmodule ElixirCompanies.CompaniesTest do
  use ElixirCompanies.DataCase

  alias ElixirCompanies.{Companies, Schema.Company}

  describe "companies" do
    @valid_attrs %{blog: "some blog", description: "some description", github: "some github", location: "some location", name: "some name", url: "some url"}
    @update_attrs %{blog: "some updated blog", description: "some updated description", github: "some updated github", location: "some updated location", name: "some updated name", url: "some updated url"}
    @invalid_attrs %{blog: nil, description: nil, github: nil, location: nil, name: nil, url: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.blog == "some blog"
      assert company.description == "some description"
      assert company.github == "some github"
      assert company.location == "some location"
      assert company.name == "some name"
      assert company.url == "some url"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)


      assert company.blog == "some updated blog"
      assert company.description == "some updated description"
      assert company.github == "some updated github"
      assert company.location == "some updated location"
      assert company.name == "some updated name"
      assert company.url == "some updated url"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end
end
