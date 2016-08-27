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
    results = []
    client.org_issues("platanus", filter: "all", per_page: 100)
    last_response = client.last_response
    results.concat(last_response.data)
    until last_response.rels[:next].nil?
      last_response = last_response.rels[:next].get
      results.concat(last_response.data)
    end
    results.select { |issue| issue[:pull_request].nil? }
  end

  def resolve_assignee(issue, username)
    return true if issue[:assignee] && issue[:assignee][:login] == username
    return true if issue[:assignees] && issue[:assignees].any? { |a| a[:login] == username }
    false
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: "")
  end
end
