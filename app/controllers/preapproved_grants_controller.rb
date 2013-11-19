class PreapprovedGrantsController < ApplicationController
  def show
    @grant = PreapprovedGrant.find params[:id]
  end
end
