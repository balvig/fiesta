require "attr_extras/explicit"
require "erb"

module Capistrano
  module Fiesta
    class Template
      extend AttrExtras.mixin
      pattr_initialize :stories

      def render
        ERB.new(File.read(erb), nil, "-").result(binding)
      end

      private

        def erb
          File.join(File.expand_path("../../templates", __FILE__), "draft.erb")
        end
    end
  end
end
