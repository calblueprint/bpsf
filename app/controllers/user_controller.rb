class UserController < ApplicationController
  def show
    @user = User.find(params[:id])
    @pledges = Payment.find_all_by_user_id(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @pledges = Payment.find_by_user_id(params[:id])
  end

  def update
    if @user.update_attributes params[:user]
      flash[:success] = "Profile Updated!"
      redirect_to @user
    else
      render "edit"
    end
  end
end
