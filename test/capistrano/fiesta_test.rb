require 'test_helper'

class Capistrano::FiestaTest < Minitest::Test
  def test_last_released_at
    release = ::Capistrano::Fiesta::Report.new('20151009145023')
    assert_equal '2015-10-09T14:50:23Z', release.last_released_at
  end
end
