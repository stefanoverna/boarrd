module Widgets
  module NewsMultiple

    def self.available_inputs
      [
        Widgets::NewsTicker::FeedInput
      ]
    end

    def self.slug
      "news_multiple"
    end

    def self.title
      "Multiple News Widget"
    end

  end
end