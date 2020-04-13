defmodule Mix.Tasks.ExpireJobs do
  @moduledoc false

  use Mix.Task

  import Ecto.Query, warn: false

  alias Companies.{Repo, Schema.Job}

  @shortdoc "Expires all jobs that haven't been updated for a month."
  def run(_) do
    Application.ensure_all_started(:companies)

    jobs_query = from j in Job, where: j.updated_at < ago(1, "month")

    Repo.update_all(jobs_query, set: [expired: true])
    IO.puts("Jobs expired successfully.")
  end
end
