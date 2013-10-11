class Recipient::DashboardController < ApplicationController
  
  def index
    if current_user && current_user.type == 'Recipient'
      @grants = current_user.grants
    elsif
      raise CanCan::AccessDenied.new("You are not authorized to access this page.", :index, Recipient) ;
      redirect_to root_url
    end
  end
end
