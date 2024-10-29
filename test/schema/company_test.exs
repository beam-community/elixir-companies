defmodule Companies.Schema.CompanyTest do
  use ExUnit.Case

  alias Companies.Schema.Company

  @attrs %{
    name: "Acme Corp",
    website: "https://example.com/",
    github: "",
    industry: "Information Technology",
    location: %{"city" => "City", "state" => "State", "country" => "Country"},
    description: "Description of Acme Corp goes here.",
    last_changed_on: "2021-01-01"
  }

  describe "changeset/1" do
    test "returns a valid changeset" do
      assert %Ecto.Changeset{valid?: true} = Company.changeset(@attrs)
    end

    test "returns a invalid changeset for invalid industry values" do
      invalid_attrs = Map.put(@attrs, :industry, "Invalid Industry")
      assert %Ecto.Changeset{valid?: false, errors: [industry: {"is invalid", _}]} = Company.changeset(invalid_attrs)
    end
  end
end
