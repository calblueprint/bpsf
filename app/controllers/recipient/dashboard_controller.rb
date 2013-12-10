# Controller to display the recipient dashboard
class Recipient::DashboardController < ApplicationController
  def index
    if recipient? && current_user.approved
      @draft_grants = current_user.draft_grants
      @grants = current_user.grants.paginate :page => params[:page], :per_page => 1
    else
      raise CanCan::AccessDenied.new
    end
  end
end
