class SuperCrowdendingJob
  include SuckerPunch::Job

  def perform(grant,admin)
    ::UserMailer.super_crowdending(grant, admin).deliver
  end

end
