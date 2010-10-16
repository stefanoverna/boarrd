require 'widgets'

class WidgetsController < ApplicationController
  load_and_authorize_resource

  before_filter do
    @dashboard = Dashboard.find(params[:dashboard_id])
  end

  def create

    @widget_slug = params[:widget][:widget_type]

    @widget = Widget.new(params[:widget])
    @widget.dashboard = @dashboard

    widget_module = Widgets::available_widgets.find do |widget|
      widget.slug == @widget_slug
    end

    @widget.widget_type = widget_module.name

    maximum_position = Widget.where(:dashboard_id => @dashboard, :area => @widget.area).maximum("area_position")
    @widget.area_position = maximum_position ? maximum_position + 1 : 0

    if @widget.save
      render :template => ("widgets/%s/view" % widget_module.slug)
    else
      render :template => "widgets/errors"
    end

  end

end