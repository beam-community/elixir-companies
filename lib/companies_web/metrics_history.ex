defmodule CompaniesWeb.MetricsHistory do
  @moduledoc """
  History for Telemetry events in dashboard metrics for LiveDashboard.
  """
  use GenServer
  alias Phoenix.LiveDashboard.TelemetryListener

  @history_buffer_size 500

  def data(metric) do
    GenServer.call(__MODULE__, {:data, metric})
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(metrics) do
    GenServer.cast(__MODULE__, {:metrics, metrics})
    {:ok, %{}}
  end

  def handle_cast({:metrics, metrics}, _state) do
    {:noreply,
     for metric <- metrics, reduce: %{} do
       acc ->
         key_metrics = Map.get(acc, event(metric.name), [])
         metric_map = %{metric: metric, history: CircularBuffer.new(@history_buffer_size)}
         attach_handler(metric, length(key_metrics))

         Map.merge(acc, %{event(metric.name) => [metric_map | key_metrics]})
     end}
  end

  defp attach_handler(%{name: name_list} = metric, id) do
    :telemetry.attach(
      "#{inspect(name_list)}-history-#{id}",
      event(name_list),
      &__MODULE__.handle_event/4,
      metric
    )
  end

  defp event(name_list) do
    Enum.slice(name_list, 0, length(name_list) - 1)
  end

  def handle_event(event_name, data, metadata, metric) do
    GenServer.cast(__MODULE__, {:telemetry_metric, event_name, data, metadata, metric})
  end

  def handle_cast({:telemetry_metric, event_name, data, metadata, metric}, state) do
    if histories_list = state[event_name] do
      time = System.system_time(:microsecond)

      {%{history: history}, index} =
        histories_list
        |> Enum.with_index()
        |> Enum.find(fn {map, _index} -> map.metric == metric end)

      measurement = TelemetryListener.extract_measurement(metric, data)
      label = TelemetryListener.tags_to_label(metric, metadata)

      new_history = CircularBuffer.insert(history, %{label: label, measurement: measurement, time: time})

      new_histories_list = List.replace_at(histories_list, index, %{metric: metric, history: new_history})

      {:noreply, %{state | event_name => new_histories_list}}
    else
      {:noreply, state}
    end
  end

  def handle_call({:data, metric}, _from, state) do
    if metric_map = state[event(metric.name)] do
      %{history: history} = Enum.find(metric_map, &(&1.metric == metric))
      {:reply, CircularBuffer.to_list(history), state}
    else
      {:reply, [], state}
    end
  end
end
