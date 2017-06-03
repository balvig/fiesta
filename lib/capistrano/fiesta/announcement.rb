require "attr_extras/explicit"
require "capistrano/fiesta/slack_dummy"

module Capistrano
  module Fiesta
    class Announcement
      extend AttrExtras.mixin
      pattr_initialize :text, :config

      def post
        client.post(options)
        text
      end

      private

        def options
          config.merge(payload: payload)
        end

        def payload
          config.fetch(:payload, {}).merge(text: text)
        end

        def client
          Slackistrano
        rescue NameError
          SlackDummy.new
        end
    end
  end
end
