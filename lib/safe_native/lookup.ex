defmodule SafeNative.Lookup do
  @moduledoc false

  use GenServer
  require Logger

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, options)
  end

  @impl true
  def init(_options) do
    {:ok, %{}}
  end
end
