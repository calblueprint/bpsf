
module SessionsHelper

  def deny_access(options)
    store_location(options)
    redirect_to new_user_session_path
  end

  def anyone_signed_in?
    !current_user.nil?
  end

  private

  def store_location(options)
    if options[:url]
      session[:return_to] = options[:url]
    else
      session[:return_to] = request.fullpath
    end
  end

  def clear_stored_location
    session[:return_to] = nil
  end

end
