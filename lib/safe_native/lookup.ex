defmodule SafeNative.Lookup do
  @moduledoc false

  use GenServer
  require Logger

  def start_link(options \\ []) do
    case options[:name] do
      nil -> GenServer.start_link(__MODULE__, options)
      name -> GenServer.start_link(__MODULE__, options, name: name)
    end
  end

  def get(key) do
    get(SafeNative, key)
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def put(key, value) do
    put(SafeNative, key, value)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def delete(key) do
    delete(SafeNative, key)
  end

  def delete(pid, key) do
    GenServer.cast(pid, {:delete, key})
  end

  @impl true
  def init(options) do
    {:ok, Keyword.get(options, :initial_map, %{})}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    case Map.get(state, key) do
      nil -> {:reply, {:error, :not_found}, state}
      value -> {:reply, {:ok, value}, state}
    end
  end

  @impl true
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_cast({:delete, key}, state) do
    {:noreply, Map.delete(state, key)}
  end
end
