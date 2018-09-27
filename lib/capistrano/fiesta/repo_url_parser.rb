require "attr_extras/explicit"

module Capistrano
  module Fiesta
    class RepoUrlParser
      extend AttrExtras.mixin
      pattr_initialize :repo_url

      def repo
        repo_url.slice(/github.com[:\/](\S+\/\S+)\.git/, 1)
      end
    end
  end
end
