class UserController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find params[:id]
    pledges = Payment.find_all_by_user_id params[:id]
    @pledges = Array.new
    pledges.each do |pledge|
      pledge_hash = Hash.new
      pledge_hash[pledge] = Grant.find pledge.crowdfund_id
      @pledges.push pledge_hash
    end
  end

  def edit
    @user = User.find params[:id]
    @pledges = Payment.find_by_user_id params[:id]
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
