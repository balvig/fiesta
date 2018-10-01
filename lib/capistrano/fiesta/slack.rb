require "cgi"
require "net/http"
require "uri"

module Capistrano
  module Fiesta
    class Slack
      extend AttrExtras.mixin
      pattr_initialize [:team, :token, :webhook, :payload]

      def post
        uri = URI(webhook || "https://#{team}.slack.com/services/hooks/incoming-webhook?token=#{CGI.escape(token)}")
        req = Net::HTTP::Post.new(uri)
        req.content_type = "application/json"
        req.body = payload.to_json
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(req) }
      end
    end
  end
end
