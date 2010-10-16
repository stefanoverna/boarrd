module Widgets
  class SpecialWeather < BaseWidget

    self.inputs = [ Widgets::NewsTicker::FeedInput, Widgets::NewsTicker::GithubIssues, Widgets::NewsTicker::CalendarEvents ]
    self.slug = :"special-weather"
    self.title = "Weather"

  end
end
