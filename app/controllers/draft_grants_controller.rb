class DraftGrantsController < ApplicationController
  load_and_authorize_resource
  
  def new
    if current_user && current_user.type == 'Recipient'
      @draft_grant = current_user.draft_grants.build
    elsif
      raise CanCan::AccessDenied.new("You are not authorized to access this page.", :index, Recipient)
      redirect_to root_url
    end
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
    session.delete :previous
    @draft_grant = DraftGrant.find params[:id]
  end

  # One day, these will be replaced by AJAX.
  def edit_general_info
    @draft_grant = DraftGrant.find params[:id]
    session[:previous] = params[:action]
  end

  def edit_logistics
    @draft_grant = DraftGrant.find params[:id]
    session[:previous] = params[:action]
  end

  def edit_budget
    @draft_grant = DraftGrant.find params[:id]
    session[:previous] = params[:action]
  end

  def edit_methods
    @draft_grant = DraftGrant.find params[:id]
    session[:previous] = params[:action]
  end

  def update
    if @draft_grant.update_attributes params[:draft_grant]
      flash[:success] = 'Grant updated!'
      redirect_to edit_draft_path @draft_grant
    else
      render session[:previous]
    end
  end
  
end
