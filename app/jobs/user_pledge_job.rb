class UserPledgeJob
  include SuckerPunch::Job

  def perform(user, grant)
    ::UserMailer.user_pledge(user,grant).deliver
  end

end