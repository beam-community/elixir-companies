defmodule Schema.CompanyTest do
  use ExUnit.Case

  alias Companies.Schema.Company

  describe "validate_industries/1" do
    test "returns bool" do
      assert Company.validate_industries(%Company{industry: "Technology"})
      refute Company.validate_industries(%Company{industry: "Non-existant"})
    end
  end
end
