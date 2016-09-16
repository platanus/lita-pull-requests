require "lita/handlers/pull_request_helper"
require "lita/handlers/pull_request_formatter"
require 'rufus-scheduler'

module Lita
  module Handlers
    class PullRequests < Handler
      on :loaded, :load_on_start
      config :access_token
      config :room

      route /^pr show ([a-z0-9_]+)$/, :show, help: {
        t("help.clear.usage") => t("help.clear.description")
      }

      route /^pr showall$/, :get_older_than, help: {
        t("help.clear.usage") => t("help.clear.description")
      }

      def scheduler
        @scheduler ||= Rufus::Scheduler.start_new
      end

      def show(response)
        username = response.matches.pop.first
        prh = PullRequestHelper.new(config.access_token)
        prf = PullRequestFormatter.new(prh.retrieve_for_user(username))
        response.reply(prf.text)
      end

      def load_on_start(payload)
        scheduler.cron '*/1 * * * *' do
          log.info "Checking for old pull resquests..."
          prh = PullRequestHelper.new(config.access_token)
          prf = PullRequestFormatter.new(
            prh.retrieve_older_than(Date.today - 3)
          )

          robot.send_messages(
            Source.new(room: Lita::Room.find_by_name(config.room)),
            prf.text
          )
        end
      end

      Lita.register_handler(self)
    end
  end
end
