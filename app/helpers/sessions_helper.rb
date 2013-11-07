
module SessionsHelper

  def deny_access(options)
    store_location options
    redirect_to new_user_session_path
  end

  def anyone_signed_in?
    !current_user.nil?
  end

  def recipient?
    current_user && current_user.type == 'Recipient'
  end

  def admin_user?
    current_user && current_user.type == 'Admin' || current_user.type == 'SuperUser'
  end

  def super_user?
    current_user && current_user.type == 'SuperUser'
  end

  private

  def store_location(options)
    session[:return_to] = options[:url] || request.fullpath
  end

  def clear_stored_location
    session[:return_to] = nil
  end

end
