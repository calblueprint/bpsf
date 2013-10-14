class DraftGrantsController < ApplicationController
  load_and_authorize_resource
  
  def new
    @draft_grant = current_user.draft_grants.build
  end

  def create
    @draft_grant = current_user.draft_grants.build params[:draft_grant]
    if @draft_grant.save
      flash[:success] = 'Grant initialized!'
      redirect_to recipient_dashboard_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end
  
end
