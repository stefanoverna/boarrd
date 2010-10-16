require 'widgets'

class DashboardsController < ApplicationController
  inherit_resources

  before_filter :only => [:show, :destroy, :update] do
    @dashboard = Dashboard.find(params[:id])
  end

  respond_to :html
  actions :index, :show, :new, :create, :destroy

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
      :input_for_path => inputs_for_dashboards_path(:widget_type => ":widget_type"),
      :dashboard_areas_widgets => areas
    }

    show!
  end

  def inputs_for
    widget_module = Widgets::find_by_slug(params[:widget_type])
    @available_inputs = widget_module.available_inputs
    render :layout => false
  end


end