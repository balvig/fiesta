require "attr_extras/explicit"

module Fiesta
  class Story
    extend AttrExtras.mixin
    pattr_initialize :pr

    def release_note
      (release_note_in_body || title).strip
    end

    def images
      pr.body.to_s.scan(/https?:\/\/\S*\.(?:png|jpg|gif)/i)
    end

    def url
      pr.html_url
    end

    def to_markdown
      "- [#{title}](#{url})"
    end

    private

      def title
        @_title ||= pr.title.to_s.sub(/\[Delivers #\S+\]\z/, "")
      end

      def release_note_in_body
        @_release_note_in_body ||= pr.body.to_s[/_Release\snotes?\:?\s(.+?)_/im, 1]
      end
  end
end
