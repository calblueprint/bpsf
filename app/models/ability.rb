# Defines user authorizations
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Default abilities
    can :read, Grant, state: 'crowdfunding'
    can :read, Recipient
    can :manage, User, id: user.id

    if user.type == 'SuperUser'
      can :manage, :all
      cannot :destroy, SuperUser
    elsif user.type == 'Admin'
      cannot :manage, [SuperUser, Admin]
      can :manage, Admin, id: user.id
      if user.approved
        can :read, :all
        can :rate, Grant
      end
    elsif user.type == 'Recipient'
      can :manage, Recipient, id: user.id
      if user.approved
        can [:create, :read], Grant
        can :manage, DraftGrant, recipient_id: user.id
        can :create, DraftGrant
        can :read, PreapprovedGrant
      end
    end
  end

end
