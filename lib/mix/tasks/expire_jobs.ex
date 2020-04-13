defmodule Mix.Tasks.ExpireJobs do
  use Mix.Task
  alias Companies.{Repo, Schema.Job}
  import Ecto.Query, warn: false

  @shortdoc "Expires all jobs that haven't been updated for a month."
  def run(_) do
    [:postgrex, :ecto]
    |> Enum.each(&Application.ensure_all_started/1)

    Repo.start_link()

    jobs_query = from j in Job, where: j.updated_at < ago(1, "month")

    Repo.update_all(jobs_query, set: [expired: true])
    IO.puts("Jobs expired successfully.")
  end
end
