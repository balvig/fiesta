module Capistrano
  module Fiesta
    class Story
      def initialize(pr)
        @pr = pr
      end

      def release_note
        (release_note_in_body || title).strip
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

      private

        def title
          @pr.title.to_s.sub(/\[Delivers #\S+\]\z/, '')
        end

        def release_note_in_body
          @pr.body.to_s[/_Release\snote\:(.+)_/m, 1]
        end
    end
  end
end
