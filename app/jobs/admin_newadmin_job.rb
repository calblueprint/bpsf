class AdminNewAdminJob
  include SuckerPunch::Job

  def perform(user,admin)
    UserMailer.admin_newadmin(user, admin).deliver
  end

end