class GoalMetJob
  include SuckerPunch::Job

  def perform(grant, admin)
    ::UserMailer.goal_met(grant, admin).deliver
  end

end