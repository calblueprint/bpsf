# Controller for the Crowdfund model
class CrowdfundController < ApplicationController
  def create
    date = get_date_from_params
    @grant = Grant.find params[:grant_id]
    @grant.create_crowdfunder goal: params[:goal],
                              pledged_total: 0
    @grant.deadline = date
    flash[:success] = "Crowdfund started!"
    @grant.crowdfund
    redirect_to @grant
  end

  def update
    crowdfund = Crowdfund.find params[:crowdfund_id]
    new_deadline = get_date_from_params
    if crowdfund.grant.update_attributes deadline: new_deadline
      flash[:success] = 'Deadline changed!'
    else
      flash[:error] = "Deadline can't be before today"
    end
    redirect_to crowdfund.grant
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
