class GrantsController < ApplicationController
  load_and_authorize_resource

  def new
    @grant = Grant.new
  end

  def create
    # This is going to have to change to incorporate the Grant subclasses
    @grant = current_user.grants.build(params[:title])
    if @grant.save
      flash[:success] = 'Grant created!'
      redirect_to @grant
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    # This might have to change to incorporate the Grant subclasses
    if @grant.update_attributes params[:grant]
      flash[:success] = 'Grant updated!'
      redirect_to @grant
    else
      render 'edit'
    end
  end

  def show
    @grant = Grant.find params[:id]
  end

  def destroy
    Grant.find(params[:id]).destroy
    flash[:success] = 'Grant deleted.'
    redirect_to grants_url
  end
end
