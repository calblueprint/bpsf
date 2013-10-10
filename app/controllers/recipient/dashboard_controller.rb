class Recipient::DashboardController < ApplicationController
  
  def index
    @grants = current_user.grants
  end
end
