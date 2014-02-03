# Base controller
class ApplicationController < ActionController::Base
  protect_from_forgery
#  before_filter :https_redirect
  include SessionsHelper
  include SimpleCaptcha::ControllerHelpers

  rescue_from CanCan::AccessDenied do |exception|
    if !current_user || current_user.approved
      redirect_to root_path, flash: { danger: exception.message }
    else
      redirect_to root_path, flash: { danger: "Your account is pending administrator approval!" }
    end
  end

  # This code never gets executed.
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

  private

  def https_redirect
    if request.ssl? && !use_https? || !request.ssl? && use_https?
      flash.keep
      protocol = request.ssl? ? "http" : "https"
      redirect_to protocol: "#{protocol}://", status: 301
    end
  end

  def use_https?
    false
  end
end
