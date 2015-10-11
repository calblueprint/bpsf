# Controller to handle payment creation/deletion
class PaymentsController < ApplicationController

  def create
    @grant = Grant.find params[:grant_id]
    deny_access url: url_for(@grant) if !anyone_signed_in?
    create_customer_if_new_donor!
    @payment = Payment.make_payment! params[:amount], @grant, current_user
    @message = nil
    if @payment.save
      @grant.reload
      respond_to do |format|
        format.html { redirect_to payment_success_path(grant_id: @grant.id, payment_id: @payment.id) }
        format.js
      end
    else
      @message = "There was an error in processing your payment."
      respond_to do |format|
        format.html {
          flash[:danger] = @message
          redirect_to @grant
        }
        format.js
      end
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    respond_to do |format|
      format.html { redirect_to @grant }
      format.js
    end
  end

  def create_offline
    @grant = Grant.find params[:grant_id]
    @payment = Payment.make_payment! params[:amount], @grant, current_user, params[:donor_name]
    @message = nil
    if @payment.save
      @grant.reload
      respond_to do |format|
        format.html { redirect_to @grant }
        format.js
      end
    else
      @message = "There was an error in processing your payment."
      respond_to do |format|
        format.html {
          flash[:danger] = @message
          redirect_to @grant
        }
        format.js
      end
    end
  end

  def destroy
    Payment.destroy params[:id]
    flash[:success] = "Payment cancelled."
    redirect_to root_url
  end

  def success
    @grant = Grant.find params[:grant_id]
    @payment = Payment.find params[:payment_id]
  end

  private
    def create_customer_if_new_donor!
      unless current_user.stripe_token
        customer = Stripe::Customer.create email: current_user.email,
                                           card: params[:stripe_token],
                                           description: current_user.name
        current_user.stripe_token = customer.id
        current_user.save!
      end
    end
end
