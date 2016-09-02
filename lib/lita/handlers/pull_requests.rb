require "lita/handlers/pull_request_helper"
require "lita/handlers/pull_request_formatter"

module Lita
  module Handlers
    class PullRequests < Handler
      route /^pr show ([a-z0-9_]+)$/, :show, help: {
        t("help.clear.usage") => t("help.clear.description")
      }

      def show(response)
        username = response.matches.pop.first
        prh = PullRequestHelper.new(username, config.access_token)
        prf = PullRequestFormatter.new(prh.retrieve)
        response.reply(prf.text)
      end

      Lita.register_handler(self)
    end
  end
end
