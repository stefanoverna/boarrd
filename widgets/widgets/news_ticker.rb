module Widgets
  class NewsTicker < BaseWidget

    class NewsItem
      include ROXML

      xml_accessor :title
      xml_accessor :published_at, :as => Time
    end

    class Input < Widgets::Input

      xml_accessor :items, :as => [NewsItem]

      def refresh
        self.items = []
      end

    end

    class FeedInput < Input
      include Widgets::Configurable

      setting :url do
        input :as => :url
        label "Feed URL"
        hint "The feed you want to visualize"
        default_value "http://"
        is_required
        has_format :with => URI::regexp(["http", "https"])
      end

      setting :items_count do
        input :as => :select, :collection => 1..20
        label "The number of items to visualize"
        default_value 5
        is_required
        is_numerical :only_integer => true
      end

      def refresh
        unless self.valid?
          throw :validation_errors
        end
        feed = Feedzirra::Feed.fetch_and_parse(self.url)
        self.items = []
        feed.entries[0..self.items_count.to_i].each do |entry|
          item = NewsItem.new
          item.title = entry.title
          item.published_at = entry.published
          self.items << item
        end
      end

      self.title = "Feed Input"
      self.slug = :feed_input

    end

    self.inputs = [ Widgets::NewsTicker::FeedInput ]
    self.slug = :news_ticker
    self.title = "NewsTicker Widget"

  end
end