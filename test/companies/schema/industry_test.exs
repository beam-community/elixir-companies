defmodule Companies.Schema.IndustryTest do
  @moduledoc """
  This module holds the unit tests to the industry changeset
  """
  use Companies.DataCase

  alias Companies.Schema.Industry

  @valid_industry_params %{
    name: "Mining industry"
  }

  describe "changeset/2" do
    test "returns a valid changeset with correct parameters" do
      changeset = Industry.changeset(%Industry{}, @valid_industry_params)
      assert changeset.valid?
    end

    test "returns an invalid changeset for incorrect parameteres" do
      changeset = Industry.changeset(%Industry{}, %{})
      refute changeset.valid?
    end
  end
end
