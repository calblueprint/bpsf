# Controller for grants
class GrantsController < ApplicationController
  load_and_authorize_resource

  def edit
    @grant = @grant.decorate
  end

  def edit_general_info
  end

  def edit_project_info
  end

  def edit_budget
  end

  def edit_methods
  end

  def update
    if @grant.update_attributes params[:grant]
      render :crop and return if params[:grant][:image].present?
      flash[:success] = 'Grant updated!'
      redirect_to @grant
    else
      @grant = @grant.reload.decorate
      render 'edit'
    end
  end

  def show
    @grant = @grant.decorate
    @crowdfund = @grant.crowdfunder
    @payment = Payment.new
  end

  def destroy
    Grant.destroy params[:id]
    flash[:success] = 'Grant deleted.'
    redirect_to grants_url
  end

  def previous_show
    @grant = @grant.decorate
  end

  def to_draft
    grant = Grant.find params[:id]
    draft = grant.clone_into_draft!
    redirect_to edit_draft_path draft
  end
end
