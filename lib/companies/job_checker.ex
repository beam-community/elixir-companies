defmodule Companies.JobChecker do
  alias Companies.Jobs

  def check_job(%{url: url} = job) do
    case HTTPoison.head(url) do
      {:ok, %{status_code: 404}} -> Jobs.delete(job)
      _ -> nil
    end
  end

  def check_all do
    Enum.each(Jobs.all(), &check_job(&1))
  end
end
