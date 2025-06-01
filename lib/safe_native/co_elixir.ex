defmodule SafeNative.CoElixir do
  @moduledoc false

  use GenServer
  require Logger

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, options)
  end

  @impl true
  def init(options \\ []) do
    a_process = %{options: options, running: false, worker_node: nil}
    {:ok, a_process, {:continue, :co_elixir}}
  end

  @impl true
  def handle_continue(:co_elixir, a_process) do
    {:noreply, a_process}
  end

  @impl true
  def handle_call({:get_worker_pid, worker_node}, _from, a_process) do
    case a_process.worker_node do
      nil ->
        case SafeNative.Lookup.get(worker_node) do
          {:error, :not_found} ->
            {:reply, {:error, :not_found}, a_process}

          _ ->
            raise RuntimeError,
                  "Invalid status on #{inspect(worker_node)}, due to unmatched status."
        end

      ^worker_node ->
        case SafeNative.Lookup.get(worker_node) do
          {:ok, pid} ->
            {:reply, {:ok, pid}, a_process}

          _ ->
            raise RuntimeError,
                  "Invalid status on #{inspect(worker_node)}, due to unmatched status."
        end

      _ ->
        raise RuntimeError, "Invalid status on #{inspect(worker_node)}, due to unmatched status."
    end
  end

  @impl true
  def handle_call({:register_worker_node, worker_node, pid}, _from, a_process) do
    Logger.info("registering #{inspect(worker_node)}")
    :ok = SafeNative.Lookup.put(worker_node, pid)
    {:reply, :ok, %{a_process | worker_node: worker_node}}
  end

  @impl true
  def handle_call({:deregister_worker_node, worker_node}, _from, a_process) do
    Logger.info("deregistering #{inspect(worker_node)}")
    :ok = SafeNative.Lookup.delete(worker_node)
    {:reply, :ok, %{a_process | worker_node: nil}}
  end
end
