defmodule SafeNativeTest do
  use ExUnit.Case
  doctest SafeNative

  test "greets the world" do
    assert SafeNative.hello() == :world
  end
end
