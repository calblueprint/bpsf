class ThankDonorJob
  include SuckerPunch::Job

  def perform(user,grant,subject,message)
    ::UserMailer.thank_donor(user,grant,subject,message).deliver
  end

end