require 'webmock/minitest'
require 'multi_json'

class WebMock::RequestStub
  def to_return_json(hash, options = {})
    options[:body] = MultiJson.dump(hash)
    options[:headers] = { content_type: "application/json" }
    to_return(options)
  end
end
