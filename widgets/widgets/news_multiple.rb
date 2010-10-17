module Widgets
  class NewsMultiple < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput, Widgets::NewsTicker::GithubIssues, Widgets::NewsTicker::GithubCommits, Widgets::NewsTicker::CalendarEvents, Widgets::NewsTicker::FacebookFeedInput, Widgets::NewsTicker::TwitterSearch ]
    self.slug = :"news-multiple"
    self.title = "Multi-Line"

  end

end
