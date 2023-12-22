defmodule Companies.HelperTest do
  use ExUnit.Case

  alias Companies.Helpers

  describe "searched_list/2" do
    test "returns the original list if search_param is not provided" do
      list = [
        %{name: "Company A", industry: "Tech"},
        %{name: "Company B", industry: "Health"}
      ]

      params = %{"search" => %{"text" => nil}}

      assert Helpers.searched_list(list, params) == list
    end

    test "filters the list based on search_param" do
      list = [
        %{name: "Company A", industry: "Tech"},
        %{name: "Company B", industry: "Health"}
      ]

      params = %{"search" => %{"text" => "tech"}}

      result = Helpers.searched_list(list, params)

      assert length(result) == 1
      assert Enum.at(result, 0) == %{name: "Company A", industry: "Tech"}
    end

    test "handles case-insensitive search" do
      list = [
        %{name: "Company A", industry: "Tech"},
        %{name: "Company B", industry: "Health"}
      ]

      params = %{"search" => %{"text" => "COMPANY"}}

      result = Helpers.searched_list(list, params)

      assert length(result) == 2
      assert Enum.at(result, 0) == %{name: "Company A", industry: "Tech"}
      assert Enum.at(result, 1) == %{name: "Company B", industry: "Health"}
    end

    test "handles an empty list" do
      list = []

      params = %{"search" => %{"text" => "tech"}}

      assert Helpers.searched_list(list, params) == []
    end

    test "handles an empty search_param" do
      list = [
        %{name: "Company A", industry: "Tech"},
        %{name: "Company B", industry: "Health"}
      ]

      params = %{"search" => %{"text" => ""}}

      assert Helpers.searched_list(list, params) == list
    end

    test "handles a non-matching search_param" do
      list = [
        %{name: "Company A", industry: "Tech"},
        %{name: "Company B", industry: "Health"}
      ]

      params = %{"search" => %{"text" => "Finance"}}

      assert Helpers.searched_list(list, params) == []
    end
  end
end
