module ProfilesHelper
  def profile_for(user)
    case user.type
    when 'SuperUser'
      'admin_profile'
    when nil
      'user_profile'
    else
      "#{user.type.downcase}_profile"
    end
  end

  def edit_profile_for(user)
    case user.type
    when 'SuperUser'
      'admin_edit'
    when nil
      'user_edit'
    else
      "#{user.type.downcase}_edit"
    end
  end
end
