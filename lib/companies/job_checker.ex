defmodule Companies.JobChecker do
  @moduledoc """
  The module to handle automated PendingChange creation for the no longer present jobs.
  """

  alias Companies.{Jobs, PendingChanges}

  def check_job(%{url: url} = job) do
    case HTTPoison.head(url) do
      {:ok, %{status_code: 404}} ->
        user_id = Application.get_env(:companies, :jobs_url_checker)[:user_id]

        if Enum.empty?(PendingChanges.get_pending_changes_for(job)) do
          Jobs.delete(job, %{id: user_id})
        end

      _ ->
        nil
    end
  end

  def check_all do
    Enum.each(Jobs.all(), &check_job(&1))
  end
end
