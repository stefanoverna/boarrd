module Widgets
  class NewsTicker < BaseWidget

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

    class GithubIssues < Input
      include Widgets::Configurable

      setting :username do
        label "Github User"
        input :as => :string
        is_required
      end

      setting :repository do
        label "Repository"
        input :as => :string
        is_required
      end

      setting :status do
        label "Status"
        input :collection => ["open", "closed"]
        is_required
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end

        issue_list = ActiveSupport::JSON.decode(open("http://github.com/api/v2/json/issues/list/#{self.username}/#{self.repository}/#{self.status}").read)

        self.items = []
        issue_list["issues"].entries[0..3].each do |issue|
          item = NewsItem.new
          item.title = issue["title"]
          item.published_at = issue["updated_at"]
          self.items << item
        end

      end

      self.title = "Github Issues"
      self.slug = :"github-issues"

    end

    class CalendarEvents < Input
      include Widgets::Configurable

      setting :url do
        label ".ics URL"
        input :as => :string
        is_required
        has_format :with => URI::regexp(["http", "https"])
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end

        cals = Icalendar.parse open(self.url).read
        cal = cals.first

        self.items = []
        cal.events.sort_by(&:dtstart).delete_if{ |event| event.dtend < Date.today }[0..3].each do |event|
          item = NewsItem.new
          item.title = event.summary
          item.published_at = event.dtstart
          self.items << item
        end

      end

      self.title = "Next Calendar Events"
      self.slug = :"calendar-events"

    end

    class FeedInput < Input
      include Widgets::Configurable

      setting :url do
        input :as => :url
        label "Feed URL"
        hint "The feed you want to visualize"
        default_value "http://"
        is_required
        has_format :with => URI::regexp(["http", "https"])
      end

      setting :items_count do
        input :as => :select, :collection => 1..20
        label "The number of items to visualize"
        default_value 5
        is_required
        is_numerical :only_integer => true
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end
        feed = FeedNormalizer::FeedNormalizer.parse open(self.url)
        self.items = []
        feed.entries[0..self.items_count.to_i].each do |entry|
          item = NewsItem.new
          item.title = entry.title
          item.published_at = entry.date_published
          self.items << item
        end
      end

      self.title = "Feed Input"
      self.slug = :"feed-input"

    end

    self.inputs = [ Widgets::NewsTicker::FeedInput, Widgets::NewsTicker::GithubIssues, Widgets::NewsTicker::CalendarEvents ]
    self.slug = :"news-ticker"
    self.title = "NewsTicker Widget"

  end
end