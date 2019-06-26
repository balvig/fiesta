require "attr_extras/explicit"

module Fiesta
  class Release
    extend AttrExtras.mixin
    pattr_initialize [:repo, :name, :stories]

    def post
      github.create_release(repo, tag, name: name, body: body)
    end

    private

      def name
        @name ||= Time.now.to_i.to_s
      end

      def tag
        "release-#{name}"
      end

      def body
        stories.map(&:to_markdown).join("\n")
      end

      def github
        @_github ||= Github.client
      end
  end
end
