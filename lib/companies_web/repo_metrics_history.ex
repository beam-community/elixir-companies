defmodule CompaniesWeb.RepoMetricsHistory do
  use GenServer

  @telemetry_event [:companies, :repo, :query]
  @historic_metric [:ecto, :dashboard, :query]
  @history_buffer_size 500

  def signatures do
    %{
      @historic_metric => {__MODULE__, :data, []}
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
    if List.starts_with?(event_name, @historic_metric) do
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
    time = System.system_time(:second)
    :telemetry.execute(@historic_metric, metric_map, metadata)

    new_history = CircularBuffer.insert(history, %{data: metric_map, time: time, metadata: pruned_metadata(metadata)})

    {:noreply, %{history: new_history}}
  end

  defp pruned_metadata(metadata) do
    # for now keep it all, reminder to either keep or drop selected fields based on dashboard usage to conserve memory,
    # ideally via some published source of truth hook from dahsboard module to ensure correctness
    metadata
  end
end
