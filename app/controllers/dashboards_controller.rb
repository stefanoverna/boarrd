require 'widgets'

class DashboardsController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  def create
    @dashboard.user = current_user
    create!
  end

  def show

    areas = {}
    @dashboard.widgets.order("area, area_position").each do |widget|
      areas[widget.area] ||= []
      areas[widget.area] << widget.id
    end

    @available_widgets = Widgets::available_widgets

    @dashboard_settings = {
      :dashboard_path => dashboard_path(@dashboard),
      :dashboard_areas_widgets => areas
    }

    show!
  end

end