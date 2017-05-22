require "tempfile"

module Capistrano
  module Fiesta
    class Editor
      def initialize(content)
        @content = content
      end

      def compose
        create_temp_file
        open
        read
      end

      private

        def create_temp_file
          file << @content
          file.close
        end

        def open
          system(*(ENV["EDITOR"] || "vi").split, file.path)
        end

        def read
          file.open
          file.unlink
          file.read.each_line.map do |line|
            line unless line.start_with?("\n") || line.start_with?("#")
          end.compact.join
        end

        def file
          @file ||= Tempfile.new(['fiesta', '.md'])
        end
    end
  end
end
