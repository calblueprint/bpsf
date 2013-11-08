# Actions for the main admin dashboard page and setting the
# grant status
class Admin::DashboardController < ApplicationController
  authorize_resource :class => false

  def index
    @grants = Grant.all.sort
  end

  def grant_event
    @grant = Grant.find params[:id]
    puts params[:state]
    @grant.send params[:state]
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js
    end
  end

  def crowdfund_form
    puts "CALLED CROWD FUND ON SERVER"
    @grant = Grant.find params[:id]
    @grant.state = "crowdfunding"
    @grant.save
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js
    end
  end

end
