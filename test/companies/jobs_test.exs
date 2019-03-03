defmodule Companies.JobsTest do
  use Companies.DataCase

  import ExUnit.CaptureLog

  alias Companies.Jobs

  setup do
    {:ok, %{user: insert(:user)}}
  end

  describe "all/0" do
    test "retrieves a list of jobs" do
      insert_list(2, :job)
      assert 2 == length(Jobs.all())
    end
  end

  describe "create/2" do
    test "creates a pending change for a new job when changes are valid", %{user: user} do
      capture_log(fn ->
        assert {:ok, %{action: "create", resource: "job"}} =
                 :job
                 |> params_for()
                 |> Jobs.create(user)
      end)
    end

    test "returns an error for invalid changes", %{user: user} do
      assert {:error, _changeset} = Jobs.create(%{}, user)
    end
  end

  describe "delete/2" do
    test "creates a pending change for deleting a job", %{user: user} do
      capture_log(fn ->
        assert {:ok, %{action: "delete", resource: "job"}} =
                 :job
                 |> insert()
                 |> Jobs.delete(user)
      end)
    end
  end

  describe "update/3" do
    test "creates a pending change for job updates when changes are valid", %{user: user} do
      capture_log(fn ->
        assert {:ok, %{action: "update", resource: "job"}} =
                 :job
                 |> insert()
                 |> Jobs.update(%{title: "updated"}, user)
      end)
    end

    test "returns an error for invalid changes", %{user: user} do
      assert {:error, _changeset} =
               :job
               |> insert()
               |> Jobs.update(%{title: nil}, user)
    end
  end
end
