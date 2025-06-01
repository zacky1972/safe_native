defmodule SafeNative.LookupTest do
  use ExUnit.Case
  doctest SafeNative.Lookup

  test "initial_map and get" do
    {:ok, pid} = SafeNative.Lookup.start_link(initial_map: %{key: :value})

    assert SafeNative.Lookup.get(pid, :key) == {:ok, :value}
    assert SafeNative.Lookup.get(pid, :non) == {:error, :not_found}
  end

  test "name, initial_map, and get" do
    {:ok, _} = SafeNative.Lookup.start_link(initial_map: %{key: :value}, name: :test)

    assert SafeNative.Lookup.get(:test, :key) == {:ok, :value}
    assert SafeNative.Lookup.get(:test, :non) == {:error, :not_found}
  end

  test "get, put, and delete" do
    {:ok, pid} = SafeNative.Lookup.start_link()

    assert SafeNative.Lookup.get(pid, :key) == {:error, :not_found}
    assert SafeNative.Lookup.put(pid, :key, :value) == :ok
    assert SafeNative.Lookup.get(pid, :key) == {:ok, :value}
    assert SafeNative.Lookup.delete(pid, :key) == :ok
    assert SafeNative.Lookup.get(pid, :key) == {:error, :not_found}
  end

  test "get, put and delete for SafeNative" do
    case SafeNative.Lookup.get(:key) do
      {:error, :not_found} ->
        assert SafeNative.Lookup.put(:key, :value) == :ok
        on_exit(fn -> SafeNative.Lookup.delete(:key) end)
        assert SafeNative.Lookup.get(:key) == {:ok, :value}

      {:ok, value} ->
        on_exit(fn -> SafeNative.Lookup.put(:key, value) end)
        assert SafeNative.Lookup.put(:key, :value) == :ok
        assert SafeNative.Lookup.get(:key) == {:ok, :value}
    end
  end
end
