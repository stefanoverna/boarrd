require 'active_support/configurable'
require 'active_support/concern'
require 'validatable'
require 'roxml'

require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "input")
require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "configurable")

require File.join(File.expand_path(File.dirname(__FILE__)), "widgets", "news_ticker")

module Widgets

  def self.available_widgets
    [
      Widgets::NewsTicker,
      Widgets::NewsCycle,
      Widgets::NewsMultiple
    ]
  end

  def self.find_by_slug(slug)
    widget_module = self.available_widgets.find do |widget|
      widget.slug == slug
    end
  end

end