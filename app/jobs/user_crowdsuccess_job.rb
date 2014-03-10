class UserCrowdsuccessJob
  include SuckerPunch::Job

  def perform(user,grant)
    ::UserMailer.user_crowdsuccess(user,grant).deliver
  end

end