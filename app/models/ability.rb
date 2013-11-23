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
      can :read, :all
      cannot :manage, [SuperUser, Admin]
      can :manage, Admin, id: user.id
      can :rate, Grant
    elsif user.type == 'Recipient'
      can [:create, :read], Grant
      can :manage, DraftGrant, recipient_id: user.id
      can :create, DraftGrant
      can :read, PreapprovedGrant
      can :manage, Recipient, id: user.id
    end
  end

end
