module Widgets
  class NewsCycle < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput ]
    self.slug = :"news-cycle"
    self.title = "Cycling Widget"

  end
end
