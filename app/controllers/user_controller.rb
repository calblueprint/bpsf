class UserController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find params[:id]
    total_payments = Payment.find_all_by_user_id params[:id]
    @payments = @user.payments
    @profile = @user.profile
  end

  def edit
    @user = User.find params[:id]
    @payments = Payment.find_by_user_id params[:id]
    @profile = @user.profile
  end

  def update
    if @user.update_attributes params[:user]
      flash[:success] = 'Profile updated!'
      redirect_to user_path @user
    else
      render 'edit'
    end
  end
end
