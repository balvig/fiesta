module Capistrano
  module Fiesta
    class Story
      def initialize(pr)
        @pr = pr
      end

      def title
        @pr.title.sub(/\[Delivers #\d+\]\z/, '').strip
      end

      def images
        @pr.body.scan(/https?:\/\/\S*\.(?:png|jpg|gif)/i)
      end
    end
  end
end
