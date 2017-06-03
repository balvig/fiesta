require "test_helper"

module Capistrano::Fiesta
  class AutoComposedStoryTest < Minitest::Test
    def test_only_returning_images_with_special_anchor
      pr = OpenStruct.new(body: "one pic http://github.com/avatar.jpg and another http://google.com/fish.png#")
      assert_equal %w{http://google.com/fish.png#}, AutoComposedStory.new(pr).images
    end
  end
end
