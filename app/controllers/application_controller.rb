# Base controller
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :https_redirect
  include SessionsHelper

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

  def https_redirect
    if ENV["ENABLE_HTTPS"] == 'yes'
      if request.ssl? && !user_https? || !request.ssl? && use_https?
        flash.keep
        protocol = request.ssl? "http" : "https"
        redirect_to protocol: "#{protocol}://"
      end
    end
  end

  def use_https?
    false
  end
end
