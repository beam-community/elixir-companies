defmodule Companies.Schema.JobTest do
  @moduledoc """
  Thus module contains unit tests for the job changesets.
  """

  use Companies.DataCase

  alias Companies.Schema.Job

  @valid_job %{
    title: "test changesets",
    url: "https://www.test@example.com",
    company_id: 60
  }

  describe "job changesets" do
    test "validates correct parameters" do
      changeset = Job.changeset(%Job{}, @valid_job)
      assert changeset.valid?
      assert changeset.changes.company_id == @valid_job.company_id
    end

    test "empty attributes invalidate changeset" do
      changeset = Job.changeset(%Job{}, %{})
      refute changeset.valid?
    end
  end
end
