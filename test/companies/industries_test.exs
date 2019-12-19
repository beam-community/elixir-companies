defmodule Companies.IndustriesTest do
  use Companies.DataCase

  alias Companies.Industries

  describe "all/0" do
    test "retrieves a list of industries" do
      insert_list(2, :industry)
      %{id: deleted_id} = insert(:industry, %{removed_pending_change: build(:pending_change)})

      refute deleted_id in Enum.map(Industries.all(), & &1.id)
    end
  end
end
