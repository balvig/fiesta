require "test_helper"

module Capistrano::Fiesta
  class StoryTest < Minitest::Test
    def test_title_as_release_note
      pr = OpenStruct.new(title: "New [Cool Stuff] feature [Delivers #2123123]")
      assert_equal "New [Cool Stuff] feature", Story.new(pr).release_note
    end

    def test_title_with_trello_id_as_release_note
      pr = OpenStruct.new(title: "New [Cool Stuff] feature [Delivers #[586f50b384a655b5c009c4ca]")
      assert_equal "New [Cool Stuff] feature", Story.new(pr).release_note
    end

    def test_release_note_in_body
      pr = OpenStruct.new(body: "_Release note: This thing is amazing_")
      assert_equal "This thing is amazing", Story.new(pr).release_note
    end

    def test_images
      pr = OpenStruct.new(body: "one pic http://github.com/avatar.jpg and another http://google.com/fish.png")
      assert_equal %w{http://github.com/avatar.jpg http://google.com/fish.png}, Story.new(pr).images
    end

    def test_images_with_nil_body
      pr = OpenStruct.new(body: nil)
      assert_equal [], Story.new(pr).images
    end
  end
end
