# SafeNative

A supervising module that enables Elixir processes to be continued execution even if external native code aborting, with direct data structure exchange between Elixir and native code.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `safe_native` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:safe_native, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/safe_native>.

