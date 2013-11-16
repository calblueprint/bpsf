class RecipientProfileController < ApplicationController
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
