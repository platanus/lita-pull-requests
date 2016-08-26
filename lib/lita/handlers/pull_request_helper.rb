require "octokit"

class PullRequestHelper
  attr_accessor :username

  def initialize(username)
    self.username = username
  end

  def retrieve
    repos.flat_map do |repo|
      client.pull_requests("platanus/#{repo[:name]}").select do |pr|
        pr[:assignee] && pr[:assignee][:login] == username
      end
    end
  end

  def repos
    [*1..5].map do |i|
      client.organization_repositories("platanus", page: i, per_page: 100)
    end.flatten
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: "")
  end
end
