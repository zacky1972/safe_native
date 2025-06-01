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
end