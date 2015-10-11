require 'test_helper'

class Capistrano::FiestaTest < Minitest::Test
  def test_last_released_at
    assert_equal "2015-10-09T14:50:23Z", report.send(:last_released_at)
  end

  def test_repo
    assert_equal "balvig/capistrano-fiesta", report.send(:repo)
  end

  private

    def report
      ::Capistrano::Fiesta::Report.new('git@github.com:balvig/capistrano-fiesta.git', last_release: '20151009145023')
    end
end

module Capistrano::Fiesta
  class FeatureTest < Minitest::Test
    def test_title
      pr = OpenStruct.new(title: "New [Cool Stuff] feature [Delivers #2123123]")
      assert_equal "New [Cool Stuff] feature", Feature.new(pr).title
    end

    def test_images
      pr = OpenStruct.new(body: "one pic http://github.com/avatar.jpg and another http://google.com/fish.png")
      assert_equal %w{http://github.com/avatar.jpg http://google.com/fish.png}, Feature.new(pr).images
    end
  end
end
