module Widgets
  class NewsMultiple < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput ]
    self.slug = :news_multiple
    self.title = "Multiple News Widget"

  end

end