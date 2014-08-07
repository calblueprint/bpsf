module PhrasingHelper
  def can_edit_phrases?
    current_user.instance_of? SuperUser
  end
end
