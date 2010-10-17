require 'active_support/configurable'
require 'active_support/concern'
require 'roxml'
require 'ostruct'

require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "input")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "validation_error")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "configurable")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "base_widget")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "news_ticker")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "news_multiple")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "news_cycle")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "weather")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "flickr_widget")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "clock")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "countdown")

module Widgets

  def self.available_widgets
    [
      Widgets::NewsTicker,
      Widgets::NewsCycle,
      Widgets::NewsMultiple,
      Widgets::Weather,
      Widgets::Clock,
      Widgets::PieChart,
      Widgets::BarChart,
      Widgets::FlickrWidget
    ]
  end

  def self.available_inputs_widgets_slugs

    inputs_hash = Widgets.available_widgets.inject({}) do |result, widget|
      widget.available_inputs.inject(result) do |r, input|
        r[input.name] ||= []
        r[input.name] << widget.name
        r
      end
    end

    joined_slugs = []
    inputs_hash.each_pair do |input, widgets|
      input_class = input.split('::').reduce(Object){|cls, c| cls.const_get(c) }
      slugged_widgets = widgets.map do |widget|
        widget_class = widget.split('::').reduce(Object){|cls, c| cls.const_get(c) }
        OpenStruct.new({:value => "#{widget_class.slug}##{input_class.slug}", :label => widget_class.title })
      end
      joined_slugs << OpenStruct.new({:label => input_class.title, :widgets => slugged_widgets})
    end

    joined_slugs
  end

  def self.find_by_slug(slug)
    return nil if slug.nil?
    widget_module = self.available_widgets.find do |widget|
      widget.slug == slug.to_sym
    end
  end

end
