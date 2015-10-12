require 'test_helper'

module Capistrano::Fiesta
  class StoryTest < Minitest::Test
    def test_title
      pr = OpenStruct.new(title: "New [Cool Stuff] feature [Delivers #2123123]")
      assert_equal "New [Cool Stuff] feature", Story.new(pr).title
    end

    def test_images
      pr = OpenStruct.new(body: "one pic http://github.com/avatar.jpg and another http://google.com/fish.png")
      assert_equal %w{http://github.com/avatar.jpg http://google.com/fish.png}, Story.new(pr).images
    end
  end
end
