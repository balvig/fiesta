require "attr_extras/explicit"

module Fiesta
  class Release
    extend AttrExtras.mixin
    pattr_initialize [:repo, :name, :stories, :revision]

    def post
      github.create_release(repo, tag, options)
    end

    private

      def options
        {
          name: name,
          body: body,
          target_commitish: revision
        }.compact
      end

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
