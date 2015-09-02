# Controller for draft grants
class DraftGrantsController < ApplicationController
  load_and_authorize_resource

  def new
    if recipient?
      @draft_grant = current_user.draft_grants.build school_id: current_user.profile.school_id
      @previous_grants = current_user.previous_grants
    else
      raise CanCan::AccessDenied.new("You are not authorized to access this page.", :manage, DraftGrant)
      redirect_to root_url
    end
  end

  def create
    @draft_grant = current_user.draft_grants.build params[:draft_grant]
    if @draft_grant.save
      flash[:success] = 'Application created!'
      redirect_to edit_draft_path @draft_grant
    else
      render 'new'
    end
  end

  def edit
    @draft_grant = DraftGrant.find params[:id]
  end

  def update
    if @draft_grant.update_attributes params[:draft_grant]
      #render :crop and return if params[:draft_grant][:image].present?
      submit and return if params[:save_and_submit]
      flash[:success] = 'Application updated!'
      redirect_to edit_draft_path @draft_grant
    else
      render 'edit'
    end
  end

  def upload_image
    @draft_grant.image = params[:img]
    if @draft_grant.save
      render json: { status: :success,
                     url: @draft_grant.image.cropping.url,
                     width: @draft_grant.image_width,
                     height: @draft_grant.image_height }
    else
      render json: { status: :error, message: 'Image uploading failed.' }
    end
  end

  def crop_image
    set_draft_crop_params
    if @draft_grant.save
      render json: { status: :success,
                     url: @draft_grant.image.banner.url }
    else
      render json: { status: :error, message: 'Cropping failed.' }
    end
  end

  def submit
    if @draft_grant.submit_and_destroy
      flash[:success] = 'Application submitted!'
      redirect_to recipient_dashboard_path
    else
      render 'edit'
    end
  end

  def destroy
    DraftGrant.destroy params[:id]
    flash[:success] = 'Application deleted.'
    redirect_to recipient_dashboard_path
  end

  private

  def set_draft_crop_params
    @draft_grant.crop_x = params[:imgX1]
    @draft_grant.crop_y = params[:imgY1]
    @draft_grant.crop_w = params[:cropW]
    @draft_grant.crop_h = params[:cropH]
    @draft_grant.image_width = params[:imgW]
    @draft_grant.image_height = params[:imgH]
  end

end
