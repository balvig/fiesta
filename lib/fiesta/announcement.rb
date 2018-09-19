require "attr_extras/explicit"
require "fiesta/slack"

module Fiesta
  class Announcement
    extend AttrExtras.mixin
    pattr_initialize :text, :config

    def post
      client.post
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
        Slack.new(options)
      end
  end
end
