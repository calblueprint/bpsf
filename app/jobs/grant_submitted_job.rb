class GrantSubmittedJob
  include SuckerPunch::Job

  def perform(grant)
    ::UserMailer.grant_submitted(grant).deliver
  end

end