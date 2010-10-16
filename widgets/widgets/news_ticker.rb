module Widgets
  class NewsTicker < BaseWidget

    class NewsItem
      include ROXML

      xml_accessor :primary_text
      xml_accessor :secondary_text
      xml_accessor :optional_text
      xml_accessor :link
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
        issue_list["issues"].entries[0..6].each do |issue|
          item = NewsItem.new
          item.primary_text = issue["title"]
          item.optional_text = "by %s" % issue["user"]
          item.secondary_text = issue["body"]
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
        cal.events.sort_by(&:dtstart).delete_if{ |event| event.dtend < Date.today }[0..9].each do |event|
          item = NewsItem.new
          item.primary_text = event.summary
          item.optional_text = event.dtstart
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

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end
        feed = FeedNormalizer::FeedNormalizer.parse open(self.url)
        self.items = []
        feed.entries[0..6].each do |entry|
          item = NewsItem.new
          item.primary_text = entry.title
          item.secondary_text = entry.content
          item.optional_text = entry.date_published
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