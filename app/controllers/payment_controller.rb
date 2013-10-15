class PaymentController < ApplicationController
  def new
    @payment = Payment.new
  end

  def create
    @payment = current_user.payments.build(:amount => params[:amount])
  end

  def destroy
    Payment.find(params[:id]).destroy
    flash[:success] = "Payment cancelled."
    redirect_to root_url
  end
end
