class GrantCrowdfundingJob
  include SuckerPunch::Job

  def perform(grant)
    ::UserMailer.grant_crowdfunding(grant).deliver
  end

end