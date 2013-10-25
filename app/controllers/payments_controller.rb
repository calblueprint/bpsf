class PaymentsController < ApplicationController

  def create
    @grant = Grant.find(params[:grant_id])
    if !anyone_signed_in?
      deny_access(url: url_for(@grant))
    else
      puts params[:amount]
      @payment = current_user.payments.build(:amount => params[:amount])
      @payment.user_id = current_user.id
      @payment.crowdfund_id = @grant.id
      @payment.save
      unless current_user.stripe_token
        customer = Stripe::Customer.create(:email => current_user.email,
                                         :card => params[:stripe_token],
                                         :description => "Donor")
        current_user.stripe_token = customer.id
        current_user.save
      end
      redirect_to root_url, notice: "Donation processed!"
    end
  end

  def destroy
    Payment.find(params[:id]).destroy
    flash[:success] = "Payment cancelled."
    redirect_to root_url
  end

end
