defmodule KingOrQueenCliTest do
  use ExUnit.Case
  doctest KingOrQueenCli

  test "greets the world" do
    assert KingOrQueenCli.hello() == :world
  end
end
