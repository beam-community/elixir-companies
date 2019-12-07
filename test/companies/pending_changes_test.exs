defmodule Companies.PendingChangesTest do
  use Companies.DataCase

  import Companies.Factory
  import ExUnit.CaptureLog

  alias Companies.{Companies, PendingChanges, Schema.PendingChange}

  describe "all/1" do
    setup do
      insert(:pending_change)
      insert(:pending_change, %{approved: true})
      insert(:pending_change, %{approved: false})
      :ok
    end

    test "retrieves a paginated list of all pending changes" do
      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 1, total_pages: 1} = PendingChanges.all()
      assert [%PendingChange{approved: nil}] = entries
    end

    test "retrieves a paginated list of all approved changes" do
      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 1, total_pages: 1} =
               PendingChanges.all(%{"approved" => "true"})

      assert [%PendingChange{approved: true}] = entries
    end

    test "retrieves a paginated list of all rejected changes" do
      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 1, total_pages: 1} =
               PendingChanges.all(%{"approved" => "false"})

      assert [%PendingChange{approved: false}] = entries
    end
  end

  describe "approve/2" do
    test "approves a pending create change" do
      %{total_entries: pre_count} = Companies.all()

      %{id: id} = insert(:pending_change)
      assert {:ok, %{approved: true}} = PendingChanges.approve(id, true)
      assert Enum.empty?(PendingChanges.all())

      %{total_entries: post_count} = Companies.all()

      assert pre_count < post_count
    end

    test "approves a pending update change" do
      %{id: company_id} = insert(:company)
      %{id: id} = insert(:pending_change, %{action: "update", changes: %{id: company_id, name: "updated"}})

      assert {:ok, %{approved: true}} = PendingChanges.approve(id, true)
      assert %{entries: [%{name: "updated"}], total_entries: 1} = Companies.all()
    end

    test "approves a pending delete change" do
      %{id: company_id} = insert(:company)
      %{id: id} = insert(:pending_change, %{action: "delete", changes: %{id: company_id}})

      assert {:ok, %{approved: true}} = PendingChanges.approve(id, true)
      assert %{total_entries: 0} = Companies.all()
    end

    test "rejects a pending change" do
      %{total_entries: pre_count} = Companies.all()

      %{id: id} = insert(:pending_change)
      assert {:ok, %{approved: false}} = PendingChanges.approve(id, false)
      assert Enum.empty?(PendingChanges.all())

      assert %{total_entries: ^pre_count} = Companies.all()
    end

    test "returns an error for missing changes" do
      assert {:error, "change not found"} = PendingChanges.approve(-1, true)
    end
  end

  describe "create/4" do
    test "returns an error tuple for invalid changesets" do
      assert {:error, %{action: :create}} = PendingChanges.create(%Ecto.Changeset{valid?: false}, :create, %{})
    end

    test "creates a new pending change" do
      company = insert(:company)
      user = insert(:user)

      output =
        capture_log(fn ->
          assert {:ok, %{action: "delete", resource: "company"}} =
                   PendingChanges.create(company, :delete, user, "out of business")
        end)

      assert output =~ "NOTIFICATION"
      %{entries: entries} = PendingChanges.all()
      assert 1 == length(entries)
    end
  end

  describe "get/1" do
    test "retrieves a pending change by id" do
      %{id: id} = insert(:pending_change)
      assert %{id: ^id} = PendingChanges.get(id)
    end
  end
end
