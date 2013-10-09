class Recipient::DashboardController < ApplicationController
  authorize_resource :class => false
  
  def index
    @grants = Recipient.find(params[:recipient_id]).grants
  end
end
