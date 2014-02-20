# Controller for grants
class GrantsController < ApplicationController
  load_and_authorize_resource

  def new
    @grant = Grant.new
  end

  def create
    # This is going to have to change to incorporate the Grant subclasses
    @grant = current_user.grants.build params[:grant]
    if @grant.save
      flash[:success] = 'Grant created!'
      redirect_to @grant
    else
      render 'new'
    end
  end

  def edit
    @grant = Grant.find params[:id]
  end

  def update
    if @grant.update_attributes params[:grant]
      flash[:success] = 'Grant updated!'
      redirect_to @grant
    else
      @grant.reload
      render 'edit'
    end
  end

  def show
    @grant = Grant.find params[:id]
    @crowdfund = @grant.crowdfunder
    @payment = Payment.new
  end

  def destroy
    Grant.destroy params[:id]
    flash[:success] = 'Grant deleted.'
    redirect_to grants_url
  end

  def rate
    @grant = Grant.find params[:id]
    @grant.rate params[:stars], current_user
    respond_to do |format|
      format.html { redirect_to @grant }
      format.js
    end
  end

  def previous_show
    @grant = Grant.first
  end

end
