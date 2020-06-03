defmodule CompaniesWeb.RepoMetricsHistory do
  @moduledoc """
  GenServer to handle historical data for Ecto queries and rebroadcast to
  LiveDashboard under seperate history-focused telemetry namespace.
  """

  use GenServer

  @telemetry_event [:companies, :repo, :query]
  @history_buffer_size 500

  def signatures do
    %{
      @telemetry_event => {__MODULE__, :data, []}
    }
  end

  def telemetry_event, do: @telemetry_event

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{history: CircularBuffer.new(@history_buffer_size)}}
  end

  def data(%{event_name: event_name} = metric) do
    if List.starts_with?(event_name, @telemetry_event) do
      GenServer.call(__MODULE__, {:data, metric})
    else
      []
    end
  end

  def setup_handlers do
    :telemetry.attach(
      "aggregation-handler-#{__MODULE__}",
      @telemetry_event,
      &__MODULE__.handle_event/4,
      nil
    )
  end

  def handle_event(@telemetry_event, metric_map, metadata, config) do
    GenServer.cast(__MODULE__, {:telemetry_metric, metric_map, metadata, config})
  end

  def handle_call({:data, _metric}, _from, %{history: history}) do
    {:reply, CircularBuffer.to_list(history), %{history: history}}
  end

  def handle_cast({:telemetry_metric, metric_map, metadata, _config}, %{history: history}) do
    time = System.system_time(:microsecond)

    new_history = CircularBuffer.insert(history, %{data: metric_map, time: time, metadata: pruned_metadata(metadata)})

    {:noreply, %{history: new_history}}
  end

  defp pruned_metadata(metadata) do
    # for now keep it all, reminder to either keep or drop selected fields based on dashboard usage to conserve memory,
    # ideally via some published source of truth hook from dahsboard module to ensure correctness
    metadata
  end
end
