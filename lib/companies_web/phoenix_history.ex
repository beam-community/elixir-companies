defmodule CompaniesWeb.PhoenixHistory do
  use GenServer

  @endpoint_event [:phoenix, :endpoint, :stop]
  @router_event [:phoenix, :router_dispatch, :stop]
  @history_buffer_size 500

  def signatures do
    %{
      @endpoint_event => {__MODULE__, :data, [:endpoint]},
      @router_event => {__MODULE__, :data, [:router_dispatch]}
    }
  end

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    {:ok,
     %{
       endpoint: CircularBuffer.new(@history_buffer_size),
       router_dispatch: CircularBuffer.new(@history_buffer_size)
     }}
  end

  def data(metric, :endpoint) do
    GenServer.call(__MODULE__, {:data, metric, :endpoint})
  end

  def data(metric, :router_dispatch) do
    GenServer.call(__MODULE__, {:data, metric, :router_dispatch})
  end

  def data(_metric, _), do: []

  def setup_handlers do
    :telemetry.attach(
      "endpoint-history-handler",
      @endpoint_event,
      &__MODULE__.handle_event/4,
      nil
    )

    :telemetry.attach(
      "router-history-handler",
      @router_event,
      &__MODULE__.handle_event/4,
      nil
    )
  end

  def handle_event(@endpoint_event, metric_map, metadata, _config) do
    GenServer.cast(__MODULE__, {:telemetry_metric, metric_map, metadata, @endpoint_event})
  end

  def handle_event(@router_event, metric_map, metadata, _config) do
    GenServer.cast(__MODULE__, {:telemetry_metric, metric_map, metadata, @router_event})
  end

  def handle_call({:data, _metric, key}, _from, history) do
    {:reply, CircularBuffer.to_list(history[key]), history}
  end

  def handle_cast({:telemetry_metric, metric_map, metadata, event}, histories) do
    time = System.system_time(:microsecond)
    key = Enum.at(event, 1)

    new_history =
      CircularBuffer.insert(histories[key], %{
        data: metric_map,
        time: time,
        metadata: metadata
      })

    {:noreply, %{histories | key => new_history}}
  end
end
