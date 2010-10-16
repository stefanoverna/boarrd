class DashboardsController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  def create
    @dashboard.user = current_user
    create!
  end

end