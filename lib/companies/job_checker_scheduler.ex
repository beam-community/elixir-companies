defmodule Companies.JobChecker.Scheduler do
  @moduledoc """
  The module to run Companies.JobChecker periodically.
  """
  use GenServer

  alias Companies.JobChecker

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    {:ok, %{}, {:continue, :schedule_next_run}}
  end

  def handle_continue(:schedule_next_run, state) do
    Process.send_after(self(), :check_jobs_availability, next_run_delay())
    {:noreply, state}
  end

  def handle_info(:check_jobs_availability, state) do
    JobChecker.check_all()
    {:noreply, state, {:continue, :schedule_next_run}}
  end

  def next_run_delay do
    Application.get_env(:companies, :jobs_url_checker)[:interval]
  end
end
