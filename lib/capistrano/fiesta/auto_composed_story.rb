module Capistrano
  module Fiesta
    class AutoComposedStory < Story
      SCREENSHOT_TAG = "#"

      def release_note
        release_note_in_body
      end

      def images
        pr.body.to_s.scan(/https?:\/\/\S*\.(?:png|jpg|gif)#{SCREENSHOT_TAG}/i)
      end
    end
  end
end
