class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, Dashboard
    end
  end
end
