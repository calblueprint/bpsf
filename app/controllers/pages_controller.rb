class PagesController < ApplicationController
  MENU = ['All', 'Art & Music', 'Supplies', 'Reading', 'Science & Math', 'Field Trips', 'Other']

  def home
    @grants = Grant.crowdfunding_grants.includes(:recipient, :school)
    if params[:subject] && params[:subject] != 'All'
      @grants.select! { |grant| grant.subject_areas.include? params[:subject] }
    end
    @grants = @grants.paginate :page => params[:page], :per_page => 6
  end

  def search
    @grants = Grant.crowdfunding_grants.search params[:query]
  end

  def donors
    @user = current_user
    if admin_user? @user
      @users = User.all
    else
      raise CanCan::AccessDenied.new "You are not authorized to access this page.", :donors, Pages
      redirect_to :back
    end
  end

  def recipients
    @user = current_user
    if admin_user? @user
      @recipients = Recipient.all
    else
      raise CanCan::AccessDenied.new "You are not authorized to access this page.", :donors, Pages
      redirect_to :back
    end
  end
end
