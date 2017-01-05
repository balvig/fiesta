module Capistrano
  module Fiesta
    class SlackDummy
      class << self
        attr_accessor :log
      end

      def post(params = {})
        self.class.log = params
        Logger.warn "Install Slackistrano to announce releases on Slack"
      end
    end
  end
end
