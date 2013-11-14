class RecipientProfileController < ApplicationController

  def new
    @profile = RecipientProfile.new
  end

  def create
    @profile = current_user.recipient_profile.build params[:recipient_profile]
    if @profile.save
      flash[:success] = "Profile Created!"
      redirect_to root_url
    else
      render "new"
    end
  end

  def update
    @profile = RecipientProfile.find params[:id]
    if @profile.update_attributes params[:recipient_profile]
      flash[:success] = "Profile updated!"
      redirect_to root_url
    else
      render "edit"
    end
  end
end
