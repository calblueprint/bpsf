class Recipient::DashboardController < ApplicationController
  authorize_resource :class => false
  
  def index
    @grants = current_user.grants
  end
end
