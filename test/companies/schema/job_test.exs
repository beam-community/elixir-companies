defmodule Companies.Schema.JobTest do
  @moduledoc """
  Thus module contains unit tests for the job changesets.
  """

  use Companies.DataCase

  alias Companies.Schema.Job

  @valid_job %{
    title: "test changesets",
    url: "https://www.test@example.com",
    company_id: 60,
    remote: true
  }

  describe "changeset/2" do
    test "returns a valid changeset with correct parameters" do
      changeset = Job.changeset(%Job{}, @valid_job)
      assert changeset.valid?
    end

    test "returns an invalid changeset for incorrect parameteres" do
      changeset = Job.changeset(%Job{}, %{})
      refute changeset.valid?
    end
  end
end
