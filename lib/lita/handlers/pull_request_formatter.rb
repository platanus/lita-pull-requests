class PullRequestFormatter
  attr_accessor :pull_requests

  def initialize(pull_requests)
    self.pull_requests = pull_requests
  end

  def text
    pull_requests.map do |pr|
      "##{pr[:id]} #{pr[:title]} opened by #{pr[:user][:login]}: #{pr[:html_url]} #{pr[:created_at]}"
    end.join("\n")
  end
end
