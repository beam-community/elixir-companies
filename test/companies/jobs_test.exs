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

    test "does not retrieve deleted records" do
      %{id: deleted_id} = insert(:job, %{deleted_at: DateTime.utc_now()})
      insert_list(2, :job)

      refute deleted_id in Enum.map(Jobs.all(), & &1.id)
    end

    test "does not include jobs from deleted companies" do
      company = insert(:company, deleted_at: DateTime.utc_now())
      %{id: deleted_id} = insert(:job, company: company)
      insert_list(2, :job)

      refute deleted_id in Enum.map(Jobs.all(), & &1.id)
    end
  end

  describe "get!/1" do
    test "retrieves by id" do
      %{id: job_id} = insert(:job)

      assert %{id: ^job_id} = Jobs.get!(job_id)
    end

    test "does not retrieve deleted record" do
      job = insert(:job, %{deleted_at: DateTime.utc_now()})

      assert_raise Ecto.NoResultsError, fn -> Jobs.get!(job.id) end
    end
  end

  describe "create/2" do
    test "creates a pending change for a new job when changes are valid" do
      assert {:ok, %{}} =
               :job
               |> params_for()
               |> Jobs.create()
    end

    test "returns an error for invalid changes" do
      assert {:error, _changeset} = Jobs.create(%{})
    end
  end

  describe "delete/2" do
    test "creates a pending change for deleting a job" do
      assert {:ok, %{}} =
               :job
               |> insert()
               |> Jobs.delete()
    end
  end

  describe "update/3" do
    test "creates a pending change for job updates when changes are valid" do
      assert {:ok, %{}} =
               :job
               |> insert()
               |> Jobs.update(%{title: "updated"})
    end

    test "returns an error for invalid changes" do
      assert {:error, _changeset} =
               :job
               |> insert()
               |> Jobs.update(%{title: nil})
    end
  end
end
