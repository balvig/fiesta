require "cgi"
require "net/http"
require "uri"

module Capistrano
  module Fiesta
    class Slack
      extend AttrExtras.mixin
      pattr_initialize [:team, :token, :webhook, :via_slackbot, :payload]

      def post
        if via_slackbot
          post_as_slackbot
        else
          post_as_webhook
        end
      end

      private

        def post_as_slackbot
          uri = URI("https://#{team}.slack.com/services/hooks/slackbot?token=#{CGI.escape(token)}&channel=#{CGI.escape(payload[:channel])}")
          req = Net::HTTP::Post.new(uri)
          req.body = payload[:text]
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(req) }
        end

        def post_as_webhook
          uri = URI(webhook || "https://#{team}.slack.com/services/hooks/incoming-webhook?token=#{CGI.escape(token)}")
          req = Net::HTTP::Post.new(uri)
          req.content_type = "application/json"
          req.body = payload.to_json
          Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(req) }
        end
    end
  end
end
