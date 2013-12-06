# Controller to handle payment creation/deletion
class PaymentsController < ApplicationController

  def create
    @grant = Grant.find params[:grant_id]
    deny_access url: url_for(@grant) if !anyone_signed_in?
    @payment = Payment.make_payment! params[:amount], @grant, current_user
    create_customer_if_new_donor!

    redirect_to root_url, notice: "Donation processed!"
  end

  def destroy
    Payment.destroy params[:id]
    flash[:success] = "Payment cancelled."
    redirect_to root_url
  end

  private
    def create_customer_if_new_donor!
      unless current_user.stripe_token
        customer = Stripe::Customer.create email: current_user.email,
                                           card: params[:stripe_token],
                                           description: "Donor"
        current_user.stripe_token = customer.id
        current_user.save!
      end
    end
end
