class PreapprovedGrantsController < ApplicationController
  def show
    @grant = PreapprovedGrant.find params[:id]
  end

  def convert
    @grant = PreapprovedGrant.find params[:id]
    @grant.clone_into_draft_for! current_user.id
    redirect_to recipient_dashboard_path
  end

  def destroy
    PreapprovedGrant.destroy params[:id]
    flash[:success] = 'Preapproved grant deleted.'
    redirect_to admin_dashboard_path
  end
end
