require 'active_support/configurable'
require 'active_support/concern'
require 'roxml'

module Widgets

  def self.available_widgets
    [
      Widgets::NewsTicker,
      Widgets::NewsCycle,
      Widgets::NewsMultiple,
      Widgets::PieChart,
      Widgets::BarChart
    ]
  end

  def self.find_by_slug(slug)
    return nil if slug.nil?
    widget_module = self.available_widgets.find do |widget|
      widget.slug == slug.to_sym
    end
  end

end