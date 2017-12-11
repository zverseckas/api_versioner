defmodule ApiVersionerTest do
  use ExUnit.Case
  doctest ApiVersioner

  test "greets the world" do
    assert ApiVersioner.hello() == :world
  end
end
