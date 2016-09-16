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

      route /^pr check_pending$/, :check_pending, help: {
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
        scheduler.cron '0 11 * * *' do
          log.info "Cron triggered."
          check_pending
        end
      end

      def check_pending(response = nil)
        log.info "Checking for old pull resquests..."
        prh = PullRequestHelper.new(config.access_token)
        prf = PullRequestFormatter.new(
          prh.retrieve_older_than(Date.today - 3)
        )

        if response
          response.reply(prf.pretty_print)
        else
          robot.send_messages(
            Source.new(room: Lita::Room.find_by_name(config.room)),
            prf.pretty_print
          )
        end
      end

      Lita.register_handler(self)
    end
  end
end
