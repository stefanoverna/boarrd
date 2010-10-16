class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, Dashboard
      can :manage, Widget
    end
  end
end
