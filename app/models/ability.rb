class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.type == "Admin"
      can :manage, :all
      cannot :destroy, Admin
    elsif user.type == "Recipient"
      can :create, Grant
      can :create, DraftGrant
      can [:read, :update, :destroy], DraftGrant, recipient_id: user.id
      can :read, Recipient
    else
      can :read, Grant
      can :read, Recipient
    end
  end

end
