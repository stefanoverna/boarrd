module Widgets
  class BarChart < BaseWidget

    class GithubProjectsIssues < PieChart::Input
      include Widgets::Configurable

      setting :username do
        label "Github User"
        input :as => :string
        is_required
      end

      setting :token do
        label "Personal Token"
        input :as => :string
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end

        params = if self.token and self.login
          params = "?login=#{self.username}&token=#{self.token}"
        else
          ""
        end

        project_list = ActiveSupport::JSON.decode(open("http://github.com/api/v2/json/repos/show/#{self.username}#{params}").read)

        self.slices = project_list["repositories"][0..4].map do |repo|
          open_issue_list = ActiveSupport::JSON.decode(open("http://github.com/api/v2/json/issues/list/#{self.username}/#{repo["name"]}/open#{params}").read)

          open_slice = PieChart::Slice.new
          open_slice.label = repo["name"]
          open_slice.amount = open_issue_list["issues"].size

          open_slice
        end

      end

      self.title = "Github Projects Issues"
      self.slug = :"github-projets-issues"

    end


    class GithubTopCommitters < PieChart::Input
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

      setting :branch do
        label "Branch"
        input :as => :string
        is_required
      end

      setting :login do
        label "Personal Login"
        input :as => :string
      end

      setting :token do
        label "Personal Token"
        input :as => :string
      end

      def refresh
        unless self.valid?
          raise ValidationError, self.errors
        end

        params = if self.token and self.login
          params = "?login=#{self.login}&token=#{self.token}"
        else
          ""
        end

        commit_list = ActiveSupport::JSON.decode(open("http://github.com/api/v2/json/commits/list/#{self.username}/#{self.repository}/#{self.branch}#{params}").read)

        commits_per_user = {}
        commit_list["commits"].entries.each do |commit|
          commits_per_user[commit["committer"]["name"]] ||= 0
          commits_per_user[commit["committer"]["name"]] += 1
        end

        slices = []
        commits_per_user.each_pair do |name, commits|
          slice = PieChart::Slice.new
          slice.label = name
          slice.amount = commits
          slices << slice
        end

        self.slices = slices.sort_by(&:amount).reverse[0..4]

      end

      self.title = "Github Top Committers"
      self.slug = :"github-top-committers"

    end

    self.inputs = [ Widgets::PieChart::GithubIssues, Widgets::BarChart::GithubProjectsIssues, Widgets::BarChart::GithubTopCommitters ]
    self.slug = :"bar-chart"
    self.title = "Bar Chart"

  end
end