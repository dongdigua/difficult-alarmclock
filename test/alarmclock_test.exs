defmodule AlarmclockTest do
  use ExUnit.Case
  doctest Alarmclock

  test "greets the world" do
    assert Alarmclock.hello() == :world
  end
end
