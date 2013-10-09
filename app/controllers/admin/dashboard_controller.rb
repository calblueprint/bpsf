class Admin::DashboardController < ApplicationController
  authorize_resource :class => false
  
  def index
    @grants = Grant.all
  end
end
