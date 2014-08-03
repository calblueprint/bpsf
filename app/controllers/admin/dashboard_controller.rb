# Actions for the main admin dashboard page and setting the
# grant status
class Admin::DashboardController < ApplicationController
  include GrantsHelper
  authorize_resource :class => false

  def index
    if !current_user.approved
      raise CanCan::AccessDenied.new
    end
    @donors = User.donors
    donated = params[:donated]
    if donated && donated == 'Donated'
      @donors = User.donors.select {|user| user.payments.length > 0}
    elsif donated && donated == 'Have Not Donated'
      @donors = User.donors.select {|user| user.payments.length == 0}
    end
    @donors = @donors.paginate :page => params[:page], :per_page => 6

    @recipients = Recipient.all
    school = params[:school]
    if school && school != 'All'
      schoolId = School.find_by_name(school).id
      @recipients = Recipient.select {|recip| recip.profile.school_id == schoolId }
    end
    @recipients = @recipients.paginate :page => params[:page], :per_page => 6
    @pending_users = User.where approved: false
    @pending_users = @pending_users.paginate :page => params[:page], :per_page => 6
  end

  def grant_event
    @grant = Grant.find params[:id]
    @grant.send params[:state]
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js
    end
  end

  def load_grants
    @grants = (Grant.includes(:school).all-DraftGrant.all).sort_by(&:order_status).paginate :page => params[:page], :per_page => 6
    respond_to do |format|
      format.js
    end
  end

  def generate_csv
    start_date = hash_to_date(params[:start_date])
    end_date = hash_to_date(params[:end_date])
    if params[:grants]
      grants = Grant.updated_in_range(start_date, end_date)
      respond_to do |format|
        format.csv { send_data Grant.to_csv(grants) }
      end
    elsif params[:teachers]
      recipients = Recipient.updated_in_range(start_date, end_date)
      respond_to do |format|
        format.csv { render text: Recipient.to_csv(recipients) }
      end
    elsif params[:donors]
      users = User.updated_in_range(start_date, end_date)
      respond_to do |format|
        format.csv { render text: User.to_csv(users) }
      end
    else # params[:payments]
      payments = Payment.updated_in_range(start_date, end_date)
      respond_to do |format|
        format.csv { render text: Payment.to_csv(payments) }
      end
    end
  end

  def load_distributions
    @successful = successful
    @unsuccessful = unsuccessful
    @accepted_school = accepted_school
    @rejected_school = rejected_school
    @accepted_subject = accepted_subject
    @rejected_subject = rejected_subject
    @successful_goal = successful_goal
    @unsuccessful_goal = unsuccessful_goal
    respond_to do |format|
      format.js
    end
  end

  def use_https?
    true
  end

  private

  def hash_to_date(date_hash)
    Date.new(date_hash[:year].to_i, date_hash[:month].to_i, date_hash[:day].to_i)
  end
end
