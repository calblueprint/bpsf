# Actions for the main admin dashboard page and setting the
# grant status
class Admin::DashboardController < ApplicationController
  include GrantsHelper
  authorize_resource class: false

  def index
    if !current_user.approved
      raise CanCan::AccessDenied.new
    end

    @grant_report = GrantReport.new(params[:grant_report])
    respond_to do |f|
      f.html do
        @grant_report.scope {|scope| scope.page(params[:page]) }
      end
      f.csv do
        send_data @grant_report.to_csv,
          type: "text/csv",
          disposition: 'inline',
          filename: "grant-report-#{Time.now.to_s}.csv"
      end
    end
    order = params[:order]
    if order && order == 'Status'
      @grants.sort_by! {|g| [g.order_status, g.title]}
    elsif order && order == 'Title'
      @grants.sort_by! {|g| g.title}
    elsif order && order == 'Last Created Date'
      @grants.sort_by! {|g| g.created_at}.reverse!
    elsif order && order == 'Last Updated Date'
      @grants.sort_by! {|g| g.updated_at}.reverse!
    end

    @donors = User.donors
    donated = params[:donated]
    if donated && donated == 'Donated'
      @donors = User.donors.select {|user| user.payments.length > 0}
    elsif donated && donated == 'Have Not Donated'
      @donors = User.donors.select {|user| user.payments.length == 0}
    end
    @donors.sort_by! {|u| [u.last_name, u.first_name]}
    @donors = @donors.paginate page: params[:page], per_page: 6

    @recipients = Recipient.all
    school = params[:school]
    if school && school != 'All'
      schoolId = School.find_by_name(school).id
      @recipients = Recipient.select {|recip| recip.profile.school_id == schoolId }
    end
    @recipients.sort_by! {|u| [u.last_name, u.first_name]}
    @recipients = @recipients.paginate page: params[:page], per_page: 6

  end

  def grant_event
    @grant = Grant.find params[:id]
    @grant.send params[:state]
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js
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
end
