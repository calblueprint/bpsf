# Defines user authorizations
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    id = user.id
    type = user.type

    # Default abilities
    can :read, Grant, state: 'crowdfunding'
    can :read, Recipient
    can :manage, User, id: id

    if type == 'SuperUser'
      can :manage, :all
      cannot :destroy, SuperUser
    elsif type == 'Admin'
      can :read, :all
      cannot :manage, [SuperUser, Admin]
      can :manage, Admin, id: id
      can :rate, Grant
    elsif type == 'Recipient'
      can [:create, :read], Grant
      can :manage, DraftGrant, recipient_id: id
      can :create, DraftGrant
      can :read, PreapprovedGrant
      can :manage, Recipient, id: id
    end
  end

end
