class DraftGrantsController < ApplicationController
  load_and_authorize_resource
  
  def new
    @draft_grant = current_user.draft_grants.build
  end

  def create
    @draft_grant = current_user.draft_grants.build params[:draft_grant]
    if @draft_grant.save
      flash[:success] = 'Grant initialized!'
      redirect_to edit_draft_path @draft_grant
    else
      render 'new'
    end
  end

  def edit
    @draft_grant = DraftGrant.find params[:id]
  end

  def edit_general_info
    @draft_grant = DraftGrant.find params[:id]
  end

  def edit_logistics
    @draft_grant = DraftGrant.find params[:id]
  end

  def edit_budget
    @draft_grant = DraftGrant.find params[:id]
  end

  def edit_methods
    @draft_grant = DraftGrant.find params[:id]
  end

  def update
  end
  
end
