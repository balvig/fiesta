require "test_helper"

module Capistrano::Fiesta
  class TimestampNormalizerTest < Minitest::Test
    def test_normalizing_timestamps
      time = Time.parse("2015-10-09T14:50:23Z")

      assert_equal time, TimestampNormalizer.new("20151009145023").run
      assert_equal time, TimestampNormalizer.new(time).run
    end
  end
end
