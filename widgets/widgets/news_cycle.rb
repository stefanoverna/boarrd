module Widgets
  class NewsCycle < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput ]
    self.slug = :news_cycle
    self.title = "Cycling News Widget"

  end
end