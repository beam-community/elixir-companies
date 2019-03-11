defmodule Companies.Schema.PendingChangeTest do
  @moduledoc """
  This module contains unit test for the Pending Changes changesets.
  """

  use Companies.DataCase

  alias Companies.Schema.PendingChange

  @valid_pending_change_params %{
    action: "create",
    approved: "true",
    changes: %{},
    note: "changeset_tests",
    resource: "company",
    user_id: 60
  }

  describe "changeset/2" do
    test "returns a valid changeset with correct parameters" do
      changeset = PendingChange.changeset(%PendingChange{}, @valid_pending_change_params)
      assert changeset.valid?
    end

    test "returns an invalid changeset for unsupported actions" do
      changeset = PendingChange.changeset(%PendingChange{}, %{@valid_pending_change_params | action: "edit"})
      refute changeset.valid?
    end

    test "returns an invalid changeset for unsupported resources" do
      changeset = PendingChange.changeset(%PendingChange{}, %{@valid_pending_change_params | resource: "work"})
      refute changeset.valid?
    end
  end
end
