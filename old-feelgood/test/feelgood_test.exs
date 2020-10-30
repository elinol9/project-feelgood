defmodule FeelgoodTest do
  use ExUnit.Case
  doctest Feelgood

  test "greets the world" do
    assert Feelgood.hello() == :world
  end
end
