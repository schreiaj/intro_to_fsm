defmodule FRCRobot do
  use Fsm, initial_state: :not_working

  defstate not_working do
    defevent hit_with_hammer do
      next_state :working
    end
  end

  defstate working do
    defevent give_to_software do
      next_state :not_working
    end
  end
end
