class AdminCrowdfailedJob
  include SuckerPunch::Job

  def perform(grant,user)
    ::UserMailer.admin_crowdfailed(grant,user).deliver
  end

end