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

  def pretty_print
    text = "*Lo siguientes usuarios tienen PRs pendientes :fire:* \n\n"
    list_by_user.each do |user_prs|
      text = text + "\n@#{user_prs.first[:user][:login]} \n"
      user_prs.each do |pr|
        text = text + "> *#{pr[:title]}* _actualizada por última vez #{pr[:updated_at]}_ \n"
        text = text + "> #{pr[:html_url]} \n"
      end
    end

    text
  end

  def list_by_user
    pull_requests.group_by { |pr| pr[:user][:login] }.values
  end
end
