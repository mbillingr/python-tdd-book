defmodule StatesTest do
  use ExUnit.Case
  doctest States

  test "greets the world" do
    assert States.hello() == :world
  end
end
