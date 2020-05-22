defmodule CompaniesWeb.ViewingStats do
  use GenServer

  @telemetry_event [:page_views, :count_events]
  @historic_metrics [:page_views, :companies_web]
  @history_buffer_size 500

  def signatures do
    %{
      @historic_metrics => {__MODULE__, :data, []}
    }
  end

  def telemetry_event, do: @telemetry_event

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{history: CircularBuffer.new(@history_buffer_size), current: %{}}}
  end

  def data(%{event_name: event_name} = metric) do
    if List.starts_with?(event_name, @historic_metrics) do
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

  def handle_event(@telemetry_event, map, metadata, config) do
    GenServer.cast(__MODULE__, {:telemetry_metric, map, metadata, config})
  end

  def emit do
    GenServer.cast(__MODULE__, :emit_telemetry)
  end

  def handle_call({:raw_data, _metric}, _from, %{history: history} = state) do
    {:reply, history, state}
  end

  def handle_call({:data, metric}, _from, %{history: history} = state) do
    local_metric = List.last(metric.name)

    reply =
      for {time, time_metrics} <- history,
          {^local_metric, data} <- time_metrics do
        %{data: %{local_metric => data}, time: time}
      end

    {:reply, reply, state}
  end

  def handle_cast(:emit_telemetry, %{history: history, current: current}) do
    time = System.system_time(:second)

    for {key, value} <- current do
      :telemetry.execute(@historic_metrics, %{key => value})
    end

    {:noreply, %{history: CircularBuffer.insert(history, {time, current}), current: %{}}}
  end

  def handle_cast({:telemetry_metric, metric_map, _metadata, _config}, %{current: current} = state) do
    updated_current =
      for {key, value} <- metric_map, reduce: current do
        acc -> Map.put_new(acc, key, 0) |> update_in([key], &(&1 + value))
      end

    {:noreply, %{state | current: updated_current}}
  end
end
