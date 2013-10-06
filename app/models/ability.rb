class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.type == "Admin"
      can :manage, :all
      cannot :destroy, Admin
    elsif user.type == "Recipient"
      can :crud, Grant
      can :update, Grant do |grant|
        grant && grant.user_id = user.id
      end
      cannot :destroy, Grant
      can :read, Recipient
    elsif user.type == "User"
      can :read, Grant
      can :read, Recipient
    end
  end

end
