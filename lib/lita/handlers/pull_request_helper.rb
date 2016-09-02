require "octokit"

class PullRequestHelper
  attr_accessor :username

  def initialize(username, access_token)
    self.username = username
    self.access_token = access_token
  end

  def retrieve
    pull_requests.select do |pull|
      assigned_to_user?(pull, username)
    end
  end

  def pull_requests
    client.org_issues("platanus", filter: "all", per_page: 100)
    last_response = client.last_response
    issues = last_response.data
    until last_response.rels[:next].nil?
      last_response = last_response.rels[:next].get
      issues.concat(last_response.data)
    end
    issues.reject { |issue| issue[:pull_request].nil? }
  end

  def assigned_to_user?(pull, username)
    return true if pull[:assignee] && pull[:assignee][:login] == username
    return true if pull[:assignees] && pull[:assignees].any? { |a| a[:login] == username }
    false
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: access_token)
  end
end
