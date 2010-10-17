module Widgets
  class Clock < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput ]
    self.slug = :"clock"
    self.title = "Clock"

  end
end
