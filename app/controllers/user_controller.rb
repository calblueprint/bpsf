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
    if @user.is_a?(Recipient)
      @profile = @user.recipient_profile
    elsif @user.is_a?(Admin) or @user.is_a?(SuperUser)
      @profile = @user.admin_profile
    end
  end

  def edit
    @user = User.find params[:id]
    @payments = Payment.find_by_user_id params[:id]
    if @user.is_a?(Recipient)
      @profile = @user.recipient_profile
    elsif @user.is_a?(Admin) or @user.is_a?(SuperUser)
      @profile = @user.admin_profile
    end
  end

  def update
    if @user.is_a?(Recipient)
      @profile = @user.recipient_profile
      if @user.update_attributes(params[:user]) && @profile.update_attributes(params[:recipient_profile])
        flash[:success] = "Profile Updated!"
        redirect_to user_path id: @user.id
      end
    else
      if @user.update_attributes params[:user]
        flash[:success] = "Profile Updated!"
        redirect_to user_path id: @user.id
      else
        render "edit"
      end
    end
  end
end
