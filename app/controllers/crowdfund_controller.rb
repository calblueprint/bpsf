class CrowdfundController < ApplicationController
  def create
    date = params[:date]
    time = Time.new date[:year], date[:month], date[:day]
    c = Crowdfund.create deadline: time,
                     goal: params[:goal],
                     pledged_total: 0
    c.grant_id = params[:grant_id]
    if c.save
      flash[:success] = "Crowfund started!"
    end
    redirect_to admin_dashboard_url
  end
end
