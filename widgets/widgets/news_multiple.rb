module Widgets
  class NewsMultiple < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput ]
    self.slug = :"news-multiple"
    self.title = "Multiple News Widget"

  end

end