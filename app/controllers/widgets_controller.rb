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
    @widget.widget_type = Widgets::find_by_slug(@widget_slug).name

    maximum_position = Widget.where(:dashboard_id => @dashboard, :area => @widget.area).maximum("area_position")
    @widget.area_position = maximum_position ? maximum_position + 1 : 0

    if @widget.save
      render :template => "widgets/%s/view" % Widgets::find_by_slug(@widget_slug).slug
    else
      render :template => "widgets/errors"
    end

  end

end