defmodule TelcoTest do
  use ExUnit.Case
  doctest Telco

  test "greets the world" do
    assert Telco.hello() == :world
  end
end
