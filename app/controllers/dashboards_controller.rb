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
      areas[widget.area] << widget.it
    end

    available_widgets = Widgets::available_widgets.map do |widget|
      {
        :name => widget.name.dasherize,
        :inputs => widget.available_inputs.map do |input|
          input.name
        end
      }
    end

    @dashboard_settings = {
      :dashboard_areas_widgets => areas,
      :available_widgets => available_widgets
    }

    show!
  end

end