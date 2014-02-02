# Controller for the Crowdfund model
class CrowdfundController < ApplicationController
  def create
    time = get_date_from_params
    @grant = Grant.find params[:grant_id]
    @grant.create_crowdfunder deadline: time,
                              goal: params[:goal],
                              pledged_total: 0
    flash[:success] = "Crowdfund started!"
    @grant.crowdfund
    redirect_to @grant
  end

  def update
    crowdfund = Crowdfund.find params[:crowdfund_id]
    new_deadline = get_date_from_params
    if crowdfund.update_attributes deadline: new_deadline
      flash[:success] = 'Deadline changed!'
      redirect_to crowdfund.grant
    else
      render crowdfund.grant
    end
  end

  def use_https?
    true
  end

  private
    def get_date_from_params
      date = params[:date]
      Time.new date[:year], date[:month], date[:day]
    end
end
