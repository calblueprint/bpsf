# Controller for the Crowdfund model
class CrowdfundController < ApplicationController
  def create
    date = params[:date]
    time = Time.new date[:year], date[:month], date[:day]
    @grant = Grant.find params[:id]
    @grant.create_crowdfunder deadline: time,
                              goal: params[:goal],
                              pledged_total: 0,
    flash[:success] = "Crowdfund started!"
    @grant.crowdfund
    redirect_to @grant
  end
end
