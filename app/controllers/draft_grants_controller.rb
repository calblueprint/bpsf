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

  # One day, these will be replaced by AJAX.
  def edit_general_info
    @draft_grant = DraftGrant.find params[:id]
    session[:return_to] ||= request.referer
  end

  def edit_logistics
    @draft_grant = DraftGrant.find params[:id]
    session[:return_to] ||= request.referer
  end

  def edit_budget
    @draft_grant = DraftGrant.find params[:id]
    session[:return_to] ||= request.referer
  end

  def edit_methods
    @draft_grant = DraftGrant.find params[:id]
    session[:return_to] ||= request.referer
  end

  def update
    if @draft_grant.update_attributes params[:draft_grant]
      flash[:success] = 'Grant updated!'
      redirect_to edit_draft_path @draft_grant
    else
      redirect_to session.delete(:return_to)
    end
  end
  
end
