class AdminGrantsubmittedJob
  include SuckerPunch::Job

  def perform(grant,user)
    ::UserMailer.admin_grantsubmitted(grant, user).deliver
  end

end