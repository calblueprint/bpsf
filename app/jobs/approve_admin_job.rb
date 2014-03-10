class ApproveAdminJob
  include SuckerPunch::Job

  def perform(user)
    ::UserMailer.approve_admin(user).deliver
  end

end