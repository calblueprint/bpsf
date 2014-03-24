class GrantFundedJob
  include SuckerPunch::Job

  def perform(grant)
    ::UserMailer.grant_funded(grant).deliver
  end

end