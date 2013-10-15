class Admin::DashboardController < ApplicationController
  authorize_resource :class => false

  def index
    @grants = Grant.all
  end

  def toggle_complete
    @grant = Grant.find params[:id]
    if !@grant.complete?
      @grant.fund
    else
      @grant.reconsider
    end
    redirect_to admin_dashboard_path
  end
end
