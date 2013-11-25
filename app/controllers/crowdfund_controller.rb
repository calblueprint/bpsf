class CrowdfundController < ApplicationController
  def create
    # Do we need the date/time variable? They don't look
    # like they're being used.
    date = params[:date]
    time = Time.new date[:year], date[:month], date[:day]
    c = Crowdfund.create deadline: time,
                         goal: params[:goal],
                         pledged_total: 0,
                         grant_id: params[:grant_id]
    flash[:success] = "Crowdfund started!" if c.save
    # Why do we allow this code to run if the crowdfund didn't save?
    @grant = Grant.find params[:grant_id]
    @grant.crowdfund
    @grant.save
    redirect_to @grant
  end
end
