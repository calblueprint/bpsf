class WeeklyDigestJob
  include SuckerPunch::Job

  def perform(user, grants)
    ::UserMailer.weekly_digest(user,grants).deliver
  end

end