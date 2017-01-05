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
        @pr.body.to_s.scan(/https?:\/\/\S*\.(?:png|jpg|gif)/i)
      end

      def url
        @pr.html_url
      end

      def to_markdown
        "- [#{title}](#{url})"
      end
    end
  end
end
