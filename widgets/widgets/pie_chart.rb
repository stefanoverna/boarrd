module Widgets
  class PieChart < BaseWidget

    class Slice
      include ROXML
      xml_accessor :amount
      xml_accessor :label
    end

    class Input < Widgets::Input

      xml_accessor :slices, :as => [Slice]

      def refresh
        self.slices = []
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

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end

        open_issue_list = ActiveSupport::JSON.decode(open("http://github.com/api/v2/json/issues/list/#{self.username}/#{self.repository}/open").read)
        closed_issue_list = ActiveSupport::JSON.decode(open("http://github.com/api/v2/json/issues/list/#{self.username}/#{self.repository}/closed").read)

        open_slice = Slice.new
        open_slice.label = "Open Issues"
        open_slice.amount = open_issue_list["issues"].size

        closed_slice = Slice.new
        closed_slice.label = "Closed Issues"
        closed_slice.amount = closed_issue_list["issues"].size

        self.slices = [
          open_slice,
          closed_slice
        ]

      end

      self.title = "Open vs. Closed Github Issues"
      self.slug = :"github-issues"

    end

    self.inputs = [ Widgets::PieChart::GithubIssues ]
    self.slug = :"pie-chart"
    self.title = "Pie Chart"

  end
end