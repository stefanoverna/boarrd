require File.join(File.expand_path(File.dirname(__FILE__)), "news_ticker", "input")
require File.join(File.expand_path(File.dirname(__FILE__)), "news_ticker", "feed_input")

module Widgets
  module NewsTicker
    def self.available_inputs
      [
        Widgets::NewsTicker::FeedInput
      ]
    end
  end
end