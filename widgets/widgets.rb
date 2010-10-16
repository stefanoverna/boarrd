require 'active_support/configurable'
require 'active_support/concern'
require 'roxml'

require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "input")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "configurable")

require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "base_widget")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "news_ticker")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "news_multiple")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "news_cycle")

module Widgets

  def self.available_widgets
    [
      Widgets::NewsTicker,
      Widgets::NewsCycle,
      Widgets::NewsMultiple
    ]
  end

  def self.find_by_slug(slug)
    return nil if slug.nil?
    widget_module = self.available_widgets.find do |widget|
      widget.slug == slug.to_sym
    end
  end

end