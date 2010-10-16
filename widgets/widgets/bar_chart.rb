module Widgets
  class BarChart < BaseWidget

    class GithubProjectsIssues < PieChart::Input
      include Widgets::Configurable

      setting :username do
        label "Github User"
        input :as => :string
        is_required
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end

        project_list = ActiveSupport::JSON.decode(open("http://github.com/api/v2/json/repos/show/#{self.username}").read)

        self.slices = project_list["repositories"][0..4].map do |repo|
          open_issue_list = ActiveSupport::JSON.decode(open("http://github.com/api/v2/json/issues/list/#{self.username}/#{repo["name"]}/open").read)

          open_slice = PieChart::Slice.new
          open_slice.label = repo["name"]
          open_slice.amount = open_issue_list["issues"].size

          open_slice
        end

      end

      self.title = "Github Projects Issues"
      self.slug = :"github-projets-issues"

    end

    self.inputs = [ Widgets::PieChart::GithubIssues, Widgets::BarChart::GithubProjectsIssues ]
    self.slug = :"bar-chart"
    self.title = "Bar Chart"

  end
end