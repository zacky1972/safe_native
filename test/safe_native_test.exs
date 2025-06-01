defmodule SafeNativeTest do
  use ExUnit.Case
  doctest SafeNative

  describe "include modules" do
    test "mix test" do
      System.cmd("mix", ["deps.get"], cd: "test_support/sub1", into: IO.stream())
      System.cmd("mix", ["deps.get"], cd: "test_support/sub2", into: IO.stream())
      System.cmd("mix", ["deps.get"], cd: "test_support/include_modules", into: IO.stream())

      {_, exit_code} = System.cmd("mix", ["test"], cd: "test_support/sub1", into: IO.stream())
      assert exit_code == 0
      {_, exit_code} = System.cmd("mix", ["test"], cd: "test_support/sub2", into: IO.stream())
      assert exit_code == 0

      {_, exit_code} =
        System.cmd("mix", ["test"], cd: "test_support/include_modules", into: IO.stream())

      assert exit_code == 0
    end
  end
end
