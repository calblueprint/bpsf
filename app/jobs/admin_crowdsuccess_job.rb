class AdminCrowdsuccessJob
  include SuckerPunch::Job

  def perform(grant, admin)
    ::UserMailer.admin_crowdsuccess(grant, admin).deliver
  end

end