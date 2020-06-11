defmodule CompaniesWeb.ViewingStats do
  @moduledoc """
  GenServer to handle aggregating simple app stats and history for telemetry_poller
  to pass on to LiveDashboard.
  """

  use GenServer

  @telemetry_event [:page_views, :count_events]
  @aggregate_telemetry [:page_views, :companies_web]

  def telemetry_event, do: @telemetry_event

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{}}
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

  def handle_cast(:emit_telemetry, state) do
    for {key, value} <- state do
      :telemetry.execute(@aggregate_telemetry, %{key => value})
    end

    {:noreply, %{}}
  end

  def handle_cast({:telemetry_metric, metric_map, _metadata, _config}, state) do
    updated_state =
      for {key, value} <- metric_map, reduce: state do
        acc -> Map.put_new(acc, key, 0) |> update_in([key], &(&1 + value))
      end

    {:noreply, updated_state}
  end
end
