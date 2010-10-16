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
      Widgets::NewsTicker
    ]
  end

end