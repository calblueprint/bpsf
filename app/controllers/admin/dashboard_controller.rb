# Actions for the main admin dashboard page and setting the
# grant status
class Admin::DashboardController < ApplicationController
  authorize_resource :class => false

  def index
    @grants = Grant.all.sort
  end

  # One day, this too will be AJAX
  def grant_event
    @grant = Grant.find params[:id]
    @grant.send params[:state]
    redirect_to admin_dashboard_path
  end
end
