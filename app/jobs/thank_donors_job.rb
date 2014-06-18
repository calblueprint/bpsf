class ThankDonorsJob
  include SuckerPunch::Job

  def perform(thankdonors)
    thankdonors.deliver
  end

end