module Widgets
  class NewsCycle < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput, Widgets::NewsTicker::GithubIssues ]
    self.slug = :"news-cycle"
    self.title = "Cycling Widget"

  end
end
