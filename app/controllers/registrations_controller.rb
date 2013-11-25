class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    build_resource sign_up_params

    if simple_captcha_valid?
      if resource.save
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          WelcomeEmailJob.new.async.perform(resource)
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          clean_up_passwords resource
          respond_with resource
        end
      else
        set_flash_message :error, "invalid_captcha"
        redirect_to new_user_registration_path
      end
  end

  def update
    super
  end

  def after_sign_up_path_for(resource)
    if can_have_profile? resource
      user = User.find resource.id
      profile = user.create_profile!
      edit_user_path id: @user.id
    else
      super
    end
  end
end
