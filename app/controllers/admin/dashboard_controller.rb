class Admin::DashboardController < ApplicationController
  authorize_resource :class => false
  
  def index
    @grants = Grant.all
  end

  def toggle_complete
    @grant = Grant.find params[:id]
    if @grant.complete?
      @grant.crowdfunding = false
      @grant.crowdfund_pending = false
      @grant.pending = false
      @grant.rejected = false
      @grant.save!
    else
      @grant.pending = true
      @grant.save!
    end
    @grant.toggle! :complete
    redirect_to admin_dashboard_path
  end
end
