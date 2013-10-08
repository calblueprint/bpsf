class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.type == "Admin"
      can :manage, :all
      cannot :destroy, Admin
    elsif user.type == "Recipient"
      can :crud, Grant
      can :update, Grant do |grant|
        grant && grant.user_id = user.id
      end
      can :destroy, Grant, user_id: user.id
      can :read, Recipient
    else
      can :read, Grant
      can :read, Recipient
    end
  end

end
