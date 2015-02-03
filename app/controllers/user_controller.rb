# Handles showing and updating users
class UserController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find params[:id]
    @payments = @user.payments.includes(:crowdfund)
    @payments = @payments.paginate page: params[:page], per_page: 6
    @profile = @user.profile
  end

  def edit
    @user = User.find params[:id]
    @payments = Payment.find_by_user_id @user
    @profile = @user.profile
    session[:return_to] ||= request.referer
  end

  def update
    if @user.update_attributes params[:user]
      if params[:stripe_token]
        create_customer!
      end
      flash[:success] = 'Profile updated!'
      redirect_to session.delete(:return_to)
    else
      if params[:stripe_token]
        create_customer!
      end
      render 'edit'
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    respond_to do |format|
      format.html { redirect_to user_path @user }
      format.js
    end
  end

  def approve
    user = User.find params[:id]
    user.approved = true
    @pending_users = User.where approved: false
    if user.save!
      flash[:success] = "#{user.name} Approved!"
      ApproveAdminJob.new.async.perform(user)
    end
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js { render "update_pending_users" }
    end
  end

  def reject
    user = User.find params[:id]
    user.destroy
    @pending_users = User.where approved: false
    flash[:success] = 'User rejected.'
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js
      format.html { redirect_to admin_dashboard_path }
      format.js { render "update_pending_users" }
    end
  end

  def credit_card
    if current_user.default_card
      @card_number = "XXXX XXXX XXXX #{current_user.last4}"
      @year = current_user.default_card.exp_year
      @month = current_user.default_card.exp_month
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_attributes params[:user]
      # Sign in the user by passing validation in case his password changed
      flash[:success] = "Password Succesfully Changed"
      sign_in @user, bypass: true
    else
      flash[:error] = "Passwords must match and be longer than six characters"
    end
    redirect_to user_path @user
  end

  private
  def create_customer!
    customer = Stripe::Customer.create email: current_user.email,
                                       card: params[:stripe_token],
                                       description: current_user.name
    current_user.stripe_token = customer.id
    current_user.save!
  end

  def use_https?
    true
  end
end
