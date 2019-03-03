defmodule Companies.IndustriesTest do
  use Companies.DataCase

  alias Companies.Industries

  describe "all/0" do
    test "retrieves a list of industries" do
      insert_list(2, :industry)
      assert 2 == length(Industries.all())
    end
  end
end
