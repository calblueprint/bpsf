class UserCrowdfailedJob
  include SuckerPunch::Job

  def perform(user,grant)
    ::UserMailer.user_crowdfailed(user,grant).deliver
  end

end