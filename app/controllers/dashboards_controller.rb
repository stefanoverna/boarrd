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

  before_filter :only => [:show, :destroy, :update, :load_all_widgets] do
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
    if current_user.dashboards.count >= 2
      flash[:alert] = "Sorry, you cannot create more than 2 dashboards!"
      @dashboards = current_user.dashboards
      render "index"
      return
    end
    @dashboard = Dashboard.new(params[:dashboard])
    @dashboard.user = current_user
    if @dashboard.save
      redirect_to dashboard_url(@dashboard)
    else
      render "new"
    end
  end

  def reorder_widgets
    widgets = ActiveSupport::JSON.decode(params[:reordered_widgets])
    widgets.each do |widget_settings|
      Widget.find(widget_settings["guid"]).update_attributes({:area_position => widget_settings["area_position"], :area => widget_settings["area"]})
    end
    render :text => "true"
  end

  def load_all_widgets

  end

  def destroy
    @dashboard.destroy
    redirect_to dashboards_url
  end

  def edit

  end

  def update
    @dashboard = Dashboard.find(params[:id])

    if @dashboard.update_attributes(params[:dashboard])
      @dashboard.widgets.each do |widget|
        if widget.area.match(/[0-9]$/)[0].to_i > @dashboard.columns_count
          widget.update_attribute(:area, "area%d" % @dashboard.columns_count)
        end
      end
      redirect_to dashboard_url(@dashboard)
    else
      render "edit"
    end
  end


  def show

    areas = {}
    @dashboard.widgets.order("area, area_position").each do |widget|
      areas[widget.area] ||= []
      areas[widget.area] << widget.guid
    end

    @available_inputs_widgets_slugs = Widgets::available_inputs_widgets_slugs

    @dashboard_settings = {
      :dashboard_path => dashboard_path(@dashboard),
      :widget_show_path => dashboard_widget_path(@dashboard, ":id"),
      :load_all_widgets_path => load_all_widgets_dashboard_path(@dashboard),
      :reorder_widgets_path => reorder_widgets_dashboard_path(@dashboard),
      :editable => @dashboard.user == current_user,
      :dashboard_areas_widgets => areas
    }
  end

end