# Controller for miscellaneous pages
class PagesController < ApplicationController
  MENU = ['All','After School Program', 'Arts / Music', 'Arts / Dance', 'Arts / Drama', 
    'Arts / Visual', 'Community Service', 'Computer / Media', 'Computer Science',
    'Foreign Language / ELL / TWI','Gardening','History & Social Studies / Multi-culturalism',
    'Mathematics','Multi-subject','Nutrition','Physical Education','Physical Education',
    'Professional Development','Reading & Writing / Communication','Science & Ecology',
    'Special Ed','Special Ed','Student/Family Support / Mental Health','Other']

  def home
    @grants = Grant.crowdfunding_grants.includes :recipient, :school
    subject = params[:subject]
    if subject && subject != 'All'
      @grants = @grants.select! { |grant| grant.subject_areas.include? subject }
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
