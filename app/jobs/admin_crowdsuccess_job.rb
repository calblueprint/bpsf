class AdminCrowdsuccessJob
  include SuckerPunch::Job

  def perform(grant,user)
    ::UserMailer.admin_crowdsuccess(grant, user).deliver
  end

end