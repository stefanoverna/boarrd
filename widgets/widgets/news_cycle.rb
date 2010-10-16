module Widgets
  module NewsCycle

    def self.available_inputs
      [
        Widgets::NewsTicker::FeedInput
      ]
    end

    def self.slug
      "news_cycle"
    end

    def self.title
      "Cycling News Widget"
    end

  end
end