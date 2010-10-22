class Ability
  include CanCan::Ability

  def initialize(user)

    if user
      can [:index, :create, :new], Dashboard
      can :create, Widget
    end

    can [:destroy, :show, :load_all_widgets, :edit, :update, :reorder_widgets], Dashboard do |dashboard|
      dashboard.user == user or dashboard.public
    end

    can [:update, :destroy, :settings], Widget do |widget|
      widget.dashboard.user == user or widget.dashboard.public
    end

  end
end
