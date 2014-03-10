class GrantRejectedJob
  include SuckerPunch::Job

  def perform(grant)
    ::UserMailer.grant_rejected(grant).deliver
  end

end