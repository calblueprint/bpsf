class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, flash: { danger: exception.message }
  end

  def after_sign_in_path_for(resource) 
    return admin_dashboard_path     if resource.is_a?(Admin)
    return recipient_dashboard_path if resource.is_a?(Recipient)
  end
end
