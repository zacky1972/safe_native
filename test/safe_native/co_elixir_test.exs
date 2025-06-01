defmodule SafeNative.CoElixirTest do
  use ExUnit.Case
  doctest SafeNative.CoElixir

  alias SafeNative.CoElixir

  setup do
    # Start a new CoElixir process for each test
    {:ok, pid} = CoElixir.start_link()
    %{pid: pid}
  end

  describe "initialization" do
    test "starts with default options", %{pid: pid} do
      state = :sys.get_state(pid)
      assert state.options == []
      assert state.running
      assert state.worker_node == nil
    end

    test "starts with custom options" do
      options = [custom: :option]
      {:ok, pid} = CoElixir.start_link(options)
      state = :sys.get_state(pid)
      assert state.options == options
      assert state.running
      assert state.worker_node == nil
    end
  end

  describe "get_worker_pid" do
    test "Any exception is not raised, when get_worker_pid called, initially.", %{pid: pid} do
      case GenServer.call(pid, {:get_worker_pid, :test}) do
        {:ok, _} -> :ok
        {:error, _} -> :error
      end
    end
  end

  describe "get_worker_pid after register_worker_node and deregister_worker_node" do
    test "pid matches", %{pid: pid} do
      :ok = GenServer.call(pid, {:register_worker_node, :test, self()})

      case GenServer.call(pid, {:get_worker_pid, :test}) do
        {:ok, s} -> assert s == self()
        v -> flunk("get_worker_pid returns #{inspect(v)}")
      end

      :ok = GenServer.call(pid, {:deregister_worker_node, :test})

      case GenServer.call(pid, {:get_worker_pid, :test}) do
        {:error, :not_found} -> :ok
        v -> flunk("get_worker_pid returns #{inspect(v)}")
      end
    end
  end
end
