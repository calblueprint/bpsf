class AdminNewuserJob
  include SuckerPunch::Job

  def perform(user,admin)
    ::UserMailer.admin_newuser(user, admin).deliver
  end

end