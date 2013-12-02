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
    elsif user.type == 'Admin' && user.approved
      can :manage, Admin, id: user.id
      if user.approved
        can :read, :all
        cannot :manage, [SuperUser, Admin]
        can :rate, Grant
      else
        raise CanCan::AccessDenied.new("Your account must be approved by an administrator!")
      end
    elsif user.type == 'Recipient'
      can :manage, Recipient, id: user.id
      if user.approved
        can [:create, :read], Grant
        can :manage, DraftGrant, recipient_id: user.id
        can :create, DraftGrant
        can :read, PreapprovedGrant
      else
        raise CanCan::AccessDenied.new("Your account must be approved by an administrator!")
      end
    end
  end

end
