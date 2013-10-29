class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.type == "Admin"
      can :manage, :all
      cannot :destroy, Admin
    elsif user.type == "Recipient"
      can [:create, :read], Grant
      can :manage, DraftGrant, recipient_id: user.id
      can :create, DraftGrant
      can :read, Recipient
    else
      can :read, Grant, state: "crowdfunding"
      can :read, Recipient
    end
  end

end
