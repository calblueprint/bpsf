# Base controller
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include SimpleCaptcha::ControllerHelpers

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, flash: { danger: exception.message }
  end

  def after_sign_in_path_for(resource)
    store_location = session[:return_to]
    clear_stored_location
    store_location ? default_after_sign_in_path_for(resource) : store_location.to_s
  end

  def default_after_sign_in_path_for(resource)
    return admin_dashboard_path     if resource.is_a? Admin
    return recipient_dashboard_path if resource.is_a? Recipient
    return root_path                if resource.is_a? User
  end
end
