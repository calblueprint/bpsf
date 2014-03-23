class UserPledgeJob
  include SuckerPunch::Job

  def perform(user, grant, payment)
    ::UserMailer.user_pledge(user,grant,payment).deliver
  end

end