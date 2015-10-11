require 'test_helper'

class Capistrano::FiestaTest < Minitest::Test
  def test_last_released_at
    report = ::Capistrano::Fiesta::Report.new('', last_release: '20151009145023')
    assert_equal '2015-10-09T14:50:23Z', report.send(:last_released_at)
  end

  def test_repo
    report = ::Capistrano::Fiesta::Report.new('git@github.com:balvig/capistrano-fiesta.git')
    assert_equal 'balvig/capistrano-fiesta', report.send(:repo)
  end
end
