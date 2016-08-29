require "lita/handlers/pull_request_helper"
require "lita/handlers/pull_request_formatter"

module Lita
  module Handlers
    class PullRequests < Handler
      route /^pr show (.+)$/, :show, help: {
        t("help.clear.usage") => t("help.clear.description")
      }
      def show(response)
        username = response.matches.pop.first
        if username =~ /^[a-z0-9_]+$/
          prh = PullRequestHelper.new(username)
          prf = PullRequestFormatter.new(prh.retrieve)
          response.reply(prf.text)
        else
          response.reply(t("commands.show.error"))
        end
      end

      Lita.register_handler(self)
    end
  end
end
