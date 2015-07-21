## Modeling Games using Finite State Machines (in Elixir)

This is going to be something of an experiment in that I don't know if it will work as I'm writing it. I hope, if it doesn't work, that the reader will take away a lesson on how to go about approaching a new FRC game.

### About the Tech

I'm going to be using [Elixir](elixir-lang.org) and the [Fsm](https://github.com/sasa1977/fsm) library. I've chosen these tools because they are pretty good about getting out of the way and letting me focus on the concept. Elixir is NOT a beginner friendly language. (And also because I really wanted an excuse to play with it.)

### All Hail the FSM

So, what is an FSM? It's a really fancy way of saying "a bunch of states and ways to move between them." No, really, that's all it is. Let's model a really bad mechanical student working on the bot with a simple FSM:

We've got a collection of states for the, [:working, :not_working], a way of transitioning from :not_working to :working (:hit_with_hammer), and a way of transitioning from :working to :not_working (:give_to_software).

So, let's just assume we get the robot and it is :not_working, we can do a bunch of actions to the robot, but the only one that will change its state is :hit_with_hammer. Given that input the state machine will transition to :working. From there we can do a lot with it, but the only thing that causes a state transition is :give_to_software. So we do that and we're back to :not_working.

![](resources/img/fsm.png)

You can see that using FSMs we can model rather complicated systems with lots of rules using relatively expressive and simple rules.

### Enter Code

I'm NOT going to go through the hassle of writing a tutorial on how to write Elixir code as that's not the point of this article. Instead I'm going to explain what things are doing as we need them. We're going to be following a test driven methodology here. I actually suggest you follow the same pattern when doing more complicated FSMs because it lets you write your rules first then implement them.

#### Basic Tests

First thing is first, we need to write a test to check if FRCRobot starts out :not_working.
```elixir
# test/FRCRobotTest.exs
defmodule FRCRobotTest do
use ExUnit.Case

  test "initially, FRCRobot is not working" do
    assert FRCRobot.new.state == :not_working
  end
end
```

We can run this with ```mix test``` and are promptly met with

> ** (UndefinedFunctionError) undefined function: FRCRobot.new/0

Uh oh, we have a failing test. Let's write just enough code to make it pass.
``` elixir
# lib/FRCRobot.ex
defmodule FRCRobot do
  use Fsm, initial_state: :not_working
end
```

We also need to update our dependencies to have the fsm module. We can do that by adding ```{:fsm, "~> 0.2.0"}``` to the deps array in mix.exs. A quick ```mix deps.get``` and ```mix test``` and it's green across the board.

Next, we're going to add a bit of info about the state, in the FRCRobotTest module add:
```elixir
...
# test/FRCRobotTest.exs
test "can't give a not working robot to software" do
  assert_raise FunctionClauseError, fn ->
    FRCRobot.new |> FRCRobot.give_to_software
  end
end
...
```

To make this pass...
```elixir
...
# lib/FRCRobot.ex
defstate working do
  defevent give_to_software do
    next_state :not_working
  end
end
...
```

I can hear your questions from here, yes, I had to define the :working state even though the test specified :not_working. That's actually just a quirk of the way elixir finds its methods. Either way, your test is now correct. What if we wanted to add a test to be sure we can fix it?

```elixir
...
# test/FRCRobotTest.exs
test "we can fix the robot by hitting it" do
  x = FRCRobot.new |> FRCRobot.hit_with_hammer
  assert x.state == :working
end
...
```

To make this pass...
```elixir
...
# lib/FRCRobot.ex
defstate not_working do
  defevent hit_with_hammer do
    next_state :working
  end
end
...
```

And we've built a simple Finite State Machine. There's a few more behaviors we should test, and I've gone ahead and done those out in the final code, but I hope you can see how we could expand this for use in modeling out behavior of a robot during a game. (If you can't, don't worry, there's another post on the way about that) If you got lost or just want to run the code, it's available on [github](https://github.com/schreiaj/intro_to_fsm).
