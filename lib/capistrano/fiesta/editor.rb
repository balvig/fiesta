require "attr_extras/explicit"
require "tempfile"

module Capistrano
  module Fiesta
    class Editor
      extend AttrExtras.mixin
      pattr_initialize :content, [:comment]

      def compose
        create_temp_file
        open
        read
      end

      private

        def create_temp_file
          file << content
          file << "# #{comment}\n\n" if comment
          file.close
        end

        def open
          system(*editor_command.split, file.path)
        end

        def editor_command
          ENV["EDITOR"] || "vi"
        end

        def read
          file.open
          file.unlink
          file.read.each_line.map do |line|
            line unless line.start_with?("\n") || line.start_with?("#")
          end.compact.join
        end

        def file
          @_file ||= Tempfile.new(["fiesta", ".md"])
        end
    end
  end
end
