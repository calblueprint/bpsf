class PagesController < ApplicationController
  def home
    @grants = Grant.crowdfunding_grants.paginate(:page => params[:page], :per_page => 6)
  end

  def search
    
  end
end
