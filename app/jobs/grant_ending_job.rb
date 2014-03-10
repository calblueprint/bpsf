class GrantEndingJob
  include SuckerPunch::Job

  def perform(grant)
    ::UserMailer.grant_ending(grant).deliver
  end

end
