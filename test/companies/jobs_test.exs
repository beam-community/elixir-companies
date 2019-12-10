defmodule Companies.JobsTest do
  use Companies.DataCase

  alias Companies.Jobs

  @moduletag :capture_log

  setup do
    {:ok, %{user: insert(:user)}}
  end

  describe "all/0" do
    test "retrieves a list of jobs" do
      insert_list(2, :job)
      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 2, total_pages: 1} = Jobs.all()
      assert 2 == length(entries)
    end

    test "filter jobs by title" do
      insert(:job, title: "test job")
      insert(:job, title: "alternate")

      assert %{entries: entries, page_number: 1, page_size: 16, total_entries: 1, total_pages: 1} =
               Jobs.all(%{"search" => %{"text" => "job"}})

      assert 1 == length(entries)
    end

    test "trims leading and trailing whitespace on text search" do
      insert(:job, title: "test job")
      insert(:job, title: "alternate")

      assert %{entries: [%{title: "test job"}]} = Jobs.all(%{"search" => %{"text" => "job "}})
      assert %{entries: [%{title: "test job"}]} = Jobs.all(%{"search" => %{"text" => " job"}})
      assert %{entries: [%{title: "test job"}]} = Jobs.all(%{"search" => %{"text" => " job "}})
    end
  end

  describe "create/2" do
    test "creates a pending change for a new job when changes are valid", %{user: user} do
      assert {:ok, %{action: "create", resource: "job"}} =
               :job
               |> params_for()
               |> Jobs.create(user)
    end

    test "returns an error for invalid changes", %{user: user} do
      assert {:error, _changeset} = Jobs.create(%{}, user)
    end
  end

  describe "delete/2" do
    test "creates a pending change for deleting a job", %{user: user} do
      assert {:ok, %{action: "delete", resource: "job"}} =
               :job
               |> insert()
               |> Jobs.delete(user)
    end
  end

  describe "update/3" do
    test "creates a pending change for job updates when changes are valid", %{user: user} do
      assert {:ok, %{action: "update", resource: "job"}} =
               :job
               |> insert()
               |> Jobs.update(%{title: "updated"}, user)
    end

    test "returns an error for invalid changes", %{user: user} do
      assert {:error, _changeset} =
               :job
               |> insert()
               |> Jobs.update(%{title: nil}, user)
    end
  end
end
