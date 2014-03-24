class DonorNearendJob
  include SuckerPunch::Job

  def perform(grant,user)
    UserMailer.donor_nearend(grant,user).deliver
  end

end