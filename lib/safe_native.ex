defmodule SafeNative do
  @moduledoc """
  A supervision module for process continuity, 
  with direct data structure exchange with external native code.
  """

  def run(options \\ []) do
    options
    |> then(fn options ->
      [
        code: options[:code] || "",
        deps: options[:deps] || [],
        host_name: options[:host] || "host",
        co_elixir_name: options[:co_elixir_name] || "co_elixir"
      ]
    end)
    |> then(fn options ->
      DynamicSupervisor.start_child(
        SafeNative.DynamicSupervisor,
        {SafeNative.CoElixir, options}
      )
    end)
  end
end
