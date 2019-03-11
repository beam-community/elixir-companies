defmodule Companies.Schema.CompanyTest do
  @moduledoc """
  This module holds the unit tests to the company changeset
  """
  use Companies.DataCase

  alias Companies.Schema.Company

  @valid_company_params %{
    blog: "Company blog",
    description: "Description of the company",
    github: "github account of the company",
    location: "Amsterdam",
    name: "Company name",
    url: "link of the company",
    industry_id: 12346
  }

  describe "changeset/2" do
    test "returns a valid changeset for correct parameters" do
      changeset = Company.changeset(%Company{}, @valid_company_params)
      assert changeset.valid?
    end

    test "returns an invalid changeset for incorrect parameteres" do
      changeset = Company.changeset(%Company{}, %{})
      refute changeset.valid?
    end
  end
end
