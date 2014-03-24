class WelcomeEmailJob
  include SuckerPunch::Job

  def perform(user)
    ::UserMailer.welcome_email(user).deliver
  end

end