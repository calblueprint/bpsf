class Recipient::DashboardController < ApplicationController
  def index
    @grants = Recipient.find(params[:recipient_id]).grants
  end
end
