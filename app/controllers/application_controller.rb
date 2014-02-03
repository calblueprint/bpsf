# Base controller
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :https_redirect
  include SessionsHelper
  include SimpleCaptcha::ControllerHelpers
  after_filter :store_location

  rescue_from CanCan::AccessDenied do |exception|
    if !current_user || current_user.approved
      redirect_to root_path, flash: { danger: exception.message }
    else
      redirect_to root_path, flash: { danger: "Your account is pending administrator approval!" }
    end
  end

  def store_location
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/users/sign_out" &&
        request.fullpath != "/" &&
        !request.xhr?)
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  private

  def https_redirect
    puts use_https?
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
