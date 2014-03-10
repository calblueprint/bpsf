class WelcomeAdminJob
  include SuckerPunch::Job

  def perform(user)
    ::UserMailer.welcome_admin(user).deliver
  end

end