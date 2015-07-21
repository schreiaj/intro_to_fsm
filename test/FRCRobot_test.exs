defmodule FRCRobotTest do
  use ExUnit.Case
  test "initially, FRCRobot is not working" do
    assert FRCRobot.new.state == :not_working
  end
  test "can't give a not working robot to software" do
    assert_raise FunctionClauseError, fn ->
      FRCRobot.new |> FRCRobot.give_to_software
    end
  end
  test "we can fix the robot by hitting it" do
    x = FRCRobot.new |> FRCRobot.hit_with_hammer
    assert x.state == :working
  end

  test "when it's working we can give the robot to software" do
    x = FRCRobot.new |> FRCRobot.hit_with_hammer |> FRCRobot.give_to_software
    assert x.state == :not_working
  end

end
