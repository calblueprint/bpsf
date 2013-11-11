class PagesController < ApplicationController
  def home
    @grants = Grant.crowdfunding_grants.paginate(:page => params[:page], :per_page => 6)
  end

  def search
    @grants = Grant.crowdfunding_grants.search params[:query]
  end

  def donors
    @users = User.all
  end

  def recipients
    @recipients = Recipient.all
  end
end
