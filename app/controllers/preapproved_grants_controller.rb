class PreapprovedGrantsController < ApplicationController
  def show
    @grant = PreapprovedGrant.find params[:id]
  end

  def convert
    @grant = PreapprovedGrant.find params[:id]
    @grant.clone_into_draft_for! current_user.id
    redirect_to recipient_dashboard_path
  end

  def edit
    
  end
end
