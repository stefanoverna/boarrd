module Widgets

  module NewsTicker

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

  end

end