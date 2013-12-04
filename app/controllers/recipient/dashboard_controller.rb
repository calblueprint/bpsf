class Recipient::DashboardController < ApplicationController
  def index
    if recipient? && current_user.approved
      @draft_grants = current_user.draft_grants
      @grants = current_user.grants
    elsif
      if recipient? && !current_user.approved
        raise CanCan::AccessDenied.new("Your account is pending administrator approval!", :index, Recipient)
      else
        raise CanCan::AccessDenied.new("You are not authorized to access this page.", :index, Recipient)
      end
    end
  end
end
