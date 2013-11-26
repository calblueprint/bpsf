class UserController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find params[:id]
    total_payments = Payment.find_all_by_user_id params[:id]
    @payments = Array.new
    total_payments.each do |payment|
      payment_hash = Hash.new
      crowdfund = Crowdfund.find payment.crowdfund_id
      payment_hash[:crowdfund] = crowdfund
      payment_hash[:amount] = payment.amount
    end
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

  def approve
    user = User.find params[:id]
    user.approved = true
    if user.save!
      flash[:success] = "#{user.name} Approved!"
    end
    redirect_to admin_dashboard_path
  end

  def reject
    user = User.find params[:id]
    user.destroy
    flash[:success] = 'User rejected.'
    redirect_to admin_dashboard_path
  end
end
