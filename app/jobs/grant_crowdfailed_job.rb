class GrantCrowdfailedJob
  include SuckerPunch::Job

  def perform(grant)
    ::UserMailer.grant_crowdfailed(grant).deliver
  end

end