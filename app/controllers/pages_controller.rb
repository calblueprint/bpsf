class PagesController < ApplicationController
  def home
    @grants = Grant.where(:crowdfunding => true).paginate(:page => params[:page], :per_page => 6)
  end
end
