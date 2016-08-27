require "octokit"

class PullRequestHelper
  attr_accessor :username

  def initialize(username)
    self.username = username
  end

  def retrieve
    issues.select do |issue|
      resolve_assignee(issue, username)
    end
  end

  def issues
    [*1..10].flat_map do |i|
      client.org_issues("platanus", filter: "all", page: i, per_page: 100).reject do |issue|
        issue[:pull_request].nil?
      end
    end.flatten
  end

  def resolve_assignee(issue, username)
    if issue[:assignee]
      return true if issue[:assignee][:login] == username
    end
    if issue[:assignees]
      issue[:assignees].each do |assignee|
        return true if assignee[:login] == username
      end
    end
    false
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: "")
  end
end
