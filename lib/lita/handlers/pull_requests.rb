module Lita
  module Handlers
    class PullRequests < Handler
      # insert handler code here

      route /^pr show (.+)$/, :show, help: {
        t("help.clear.usage") => t("help.clear.description")
      }
      def show(response)
        username = response.matches.pop.first
        if username =~ /^[a-z0-9_]+$/
          prh = PullRequestHelper.new(response.matches.pop.first)
          response.reply("hola")
        else
          response.reply(t("commands.show.error"))
        end
      end

      Lita.register_handler(self)
    end
  end
end
