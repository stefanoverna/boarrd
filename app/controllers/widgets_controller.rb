require 'widgets'

class WidgetsController < ApplicationController
  load_and_authorize_resource

  before_filter do
    @dashboard = Dashboard.find(params[:dashboard_id])
  end

  def create

    @widget = Widget.new(params[:widget])
    @widget.dashboard = @dashboard

    maximum_position = Widget.where(:dashboard_id => @dashboard, :area => @widget.area).maximum("area_position")
    @widget.area_position = maximum_position ? maximum_position + 1 : 0

    if @widget.save
      render :template => "widgets/view"
    else
      render :template => "widgets/errors"
    end

  end

  def settings
    @widget = Widget.find_by_guid(params[:id])
    render :layout => false
  end

end