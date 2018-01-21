defmodule EoleTest do
  use ExUnit.Case
  doctest Eole

  test "greets the world" do
    assert Eole.hello() == :world
  end
end
