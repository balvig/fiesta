require 'test_helper'

class Capistrano::FiestaTest < Minitest::Test
  def test_last_released_at
    assert_equal "2015-10-09T14:50:23Z", report.send(:last_released_at)
  end

  def test_repo
    assert_equal "balvig/capistrano-fiesta", report.send(:repo)
  end

  def test_strip_tags
    assert_equal "New [Cool Stuff] feature", report.send(:strip_tags, "New [Cool Stuff] feature [Delivers #2123123]")
  end

  private

    def report
      ::Capistrano::Fiesta::Report.new('git@github.com:balvig/capistrano-fiesta.git', last_release: '20151009145023')
    end
end
