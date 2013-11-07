# Defines user authorizations
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Default abilities
    can :read, Grant, state: 'crowdfunding'
    can :read, Recipient

    if user.type == 'SuperUser'
      can :manage, :all
      cannot :destroy, SuperUser
    elsif user.type == 'Admin'
      can [:create, :read, :update], :all
      cannot :manage, [SuperUser, Admin]
      can :manage, Admin, id: user.id
    elsif user.type == 'Recipient'
      can [:create, :read], Grant
      can :manage, DraftGrant, recipient_id: user.id
      can :create, DraftGrant
    end
  end

end
