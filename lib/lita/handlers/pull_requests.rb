module Lita
  module Handlers
    class PullRequests < Handler
      # insert handler code here

      route /^pr show (.+)$/, :show, help: {
        t("help.clear.usage") => t("help.clear.description")
      }
      def show(response)
        prh = PullRequestHelper.new(response.matches.pop.first)
        response.reply(prh.render)
      end
      
      Lita.register_handler(self)
    end
  end
end
