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
    if current_user.is_a?(Recipient)
      @profile = current_user.recipient_profile
    end
    puts @payments.length
    puts @payments
  end

  def edit
    @user = User.find params[:id]
    @payments = Payment.find_by_user_id params[:id]
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
