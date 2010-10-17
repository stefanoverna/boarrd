require 'widgets'

class DashboardsController < ApplicationController
  load_and_authorize_resource

  layout :layout_by_resource
  def layout_by_resource
    if action_name.to_sym == :show
      "empty"
    else
      "application"
    end
  end

  before_filter :only => [:show, :destroy, :update] do
    @dashboard = Dashboard.find(params[:id])
  end

  before_filter :only => [:show] do
    @large = true
  end

  respond_to :html

  def index
    @dashboards = current_user.dashboards
  end

  def create
    @dashboard = Dashboard.new(params[:dashboard])
    @dashboard.user = current_user
    @dashboard.save
    redirect_to dashboard_url(@dashboard)
  end

  def reorder_widgets
    widgets = ActiveSupport::JSON.decode(params[:reordered_widgets])
    widgets.each do |widget_settings|
      Widget.find(widget_settings["guid"]).update_attributes({:area_position => widget_settings["area_position"], :area => widget_settings["area"]})
    end
    render :text => "true"
  end

  def destroy
    @dashboard.destroy
    redirect_to dashboards_url
  end

  def show

    areas = {}
    @dashboard.widgets.order("area, area_position").each do |widget|
      areas[widget.area] ||= []
      areas[widget.area] << widget.guid
    end

    @available_widgets = Widgets::available_widgets

    @dashboard_settings = {
      :dashboard_path => dashboard_path(@dashboard),
      :input_for_path => inputs_for_dashboards_path(:widget_type => ":widget_type"),
      :widget_show_path => dashboard_widget_path(@dashboard, ":id"),
      :reorder_widgets_path => reorder_widgets_dashboard_path(@dashboard),
      :dashboard_areas_widgets => areas
    }
  end

  def inputs_for
    widget_module = Widgets::find_by_slug(params[:widget_type])
    @available_inputs = widget_module.available_inputs
    render :layout => false
  end


end