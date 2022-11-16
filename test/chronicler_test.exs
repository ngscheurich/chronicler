defmodule ChroniclerTest do
  use ExUnit.Case
  doctest Chronicler

  test "greets the world" do
    assert Chronicler.hello() == :world
  end
end
