defmodule CompaniesWeb.VMHistory do
  use GenServer

  @run_queue_event [:vm, :total_run_queue_lengths]
  @memory_event [:vm, :memory]
  @history_buffer_size 500

  def signatures do
    %{
      @run_queue_event => {__MODULE__, :data, [:total_run_queue_lengths]},
      @memory_event => {__MODULE__, :data, [:memory]}
    }
  end

  def run_queue_event, do: @run_queue_event

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    {:ok,
     %{
       total_run_queue_lengths: CircularBuffer.new(@history_buffer_size),
       memory: CircularBuffer.new(@history_buffer_size)
     }}
  end

  def data(metric, :total_run_queue_lengths) do
    GenServer.call(__MODULE__, {:data, metric, :total_run_queue_lengths})
  end

  def data(metric, :memory) do
    GenServer.call(__MODULE__, {:data, metric, :memory})
  end

  def data(_metric, _), do: []

  def setup_handlers do
    :telemetry.attach(
      "run-queue-handler-#{__MODULE__}",
      @run_queue_event,
      &__MODULE__.handle_event/4,
      nil
    )

    :telemetry.attach(
      "memory-handler-#{__MODULE__}",
      @memory_event,
      &__MODULE__.handle_event/4,
      nil
    )
  end

  def handle_event(@run_queue_event, metric_map, metadata, _config) do
    GenServer.cast(__MODULE__, {:telemetry_metric, metric_map, metadata, @run_queue_event})
  end

  def handle_event(@memory_event, metric_map, metadata, _config) do
    GenServer.cast(__MODULE__, {:telemetry_metric, metric_map, metadata, @memory_event})
  end

  def handle_call({:data, _metric, key}, _from, history) do
    {:reply, CircularBuffer.to_list(history[key]), history}
  end

  def handle_cast({:telemetry_metric, metric_map, metadata, event}, histories) do
    time = System.system_time(:microsecond)
    key = List.last(event)

    new_history =
      CircularBuffer.insert(histories[key], %{
        data: metric_map,
        time: time,
        metadata: metadata
      })

    {:noreply, %{histories | key => new_history}}
  end
end
