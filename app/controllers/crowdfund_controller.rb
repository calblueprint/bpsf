class CrowdfundController < ApplicationController
  def create
    date = params[:date]
    time = Time.new date[:year], date[:month], date[:day]
    c = Crowdfund.create deadline: time,
                         goal: params[:goal],
                         pledged_total: 0
    c.grant_id = params[:grant_id]
    flash[:success] = "Crowdfund started!" if c.save
    @grant = Grant.find params[:grant_id]
    @grant.state = "crowdfunding"
    @grant.save
    redirect_to @grant
  end
end
