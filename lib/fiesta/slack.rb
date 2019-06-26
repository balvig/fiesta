require "cgi"
require "net/http"
require "uri"

module Fiesta
  class Slack
    extend AttrExtras.mixin
    pattr_initialize [:webhook, :payload]

    def post
      uri = URI(webhook)
      req = Net::HTTP::Post.new(uri)
      req.content_type = "application/json"
      req.body = payload.to_json
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { |http| http.request(req) }
    end
  end
end
