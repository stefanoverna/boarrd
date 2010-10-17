class Ability
  include CanCan::Ability

  def initialize(user)
    if user

      can [:index, :create, :new], Dashboard
      can [:destroy, :show, :edit, :update, :reorder_widgets], Dashboard do |dashboard|
        dashboard.user == user
      end

      can :create, Widget
      can [:update, :destroy, :settings], Widget do |widget|
        widget.dashboard.user == user
      end

    end
  end
end
