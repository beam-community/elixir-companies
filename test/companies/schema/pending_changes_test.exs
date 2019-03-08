defmodule Companies.Schema.PendingChangeTest do
  @moduledoc """
  This module contains unit test for the Pending Changes changesets.
  """

  use Companies.DataCase

  alias Companies.Schema.{
    PendingChange
  }

  @valid_pending_change %{
    action: "create",
    approved: "true",
    changes: %{},
    note: "changeset_tests",
    resource: "company",
    user_id: 60
  }

  describe "pending_change changesets" do
    test "validates correct parameters" do
      changeset = PendingChange.changeset(%PendingChange{}, @valid_pending_change)
      assert changeset.valid?
      assert changeset.changes.user_id == @valid_pending_change.user_id
    end

    test "invalidates changeset if action field is out of options set" do
      changeset = PendingChange.changeset(%PendingChange{}, %{@valid_pending_change | action: "edit"})
      refute changeset.valid?
    end

    test "invalidates changeset if resouce field is out of options set" do
      changeset = PendingChange.changeset(%PendingChange{}, %{@valid_pending_change | resource: "work"})
      refute changeset.valid?
    end
  end
end
