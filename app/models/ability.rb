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
      cannot :manage, [SuperUser, Admin]
      can :manage, Admin, id: id
      if user.approved
        can :manage, :all
        cannot :manage, SuperUser
        cannot :destroy, Admin
        can :read, :all
        can :rate, Grant
      end
    elsif type == 'Recipient'
      can :manage, Recipient, id: id
      can [:create, :read, :previous_show], Grant
      can :manage, DraftGrant, recipient_id: id
      can :create, DraftGrant
    end
  end
end
