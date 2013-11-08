class CrowdfundController < ApplicationController
  def create
    time = Time.new params[:year] params[:month] params[:day]
    Crowdfund.create deadline: time,
                     goal: params[:goal],
                     grant_id: params[:grant_id],
                     pledged_total: params[:pledged_total]
  end
end
