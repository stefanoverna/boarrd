module Widgets
  class NewsCycle < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput, Widgets::NewsTicker::GithubIssues, Widgets::NewsTicker::CalendarEvents ]
    self.slug = :"news-cycle"
    self.title = "Cycling News Widget"

  end
end