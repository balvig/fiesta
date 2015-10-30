require "erb"

module Capistrano
  module Fiesta
    class Draft
      attr_reader :comment, :stories

      def initialize(comment:, stories: [])
        @comment, @stories = comment, stories
      end

      def render
        ERB.new(File.read(template), nil, '-').result(binding)
      end

      private

        def template
          File.join(File.expand_path('../../templates', __FILE__), 'draft.erb')
        end
    end
  end
end
