# Actions for the main admin dashboard page and setting the
# grant status
class Admin::DashboardController < ApplicationController
  authorize_resource :class => false

  def index
    if !current_user.approved
      raise CanCan::AccessDenied.new
    end
    @grants = (Grant.all-DraftGrant.all).sort.paginate :page => params[:page], :per_page => 6

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

  def use_https?
    true
  end
end
