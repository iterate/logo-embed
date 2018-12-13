defmodule LogoTest do
  use ExUnit.Case
  doctest Logo

  test "greets the world" do
    assert Logo.hello() == :nerds
  end
end
