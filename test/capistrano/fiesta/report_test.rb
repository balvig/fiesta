require 'test_helper'

module Capistrano::Fiesta
  class ReportTest < Minitest::Test
    def test_last_released_at
      assert_equal "2015-10-09T14:50:23Z", report.send(:last_released_at)
    end

    def test_repo
      assert_equal "balvig/capistrano-fiesta", report.send(:repo)
    end

    private

      def report
        Report.new('git@github.com:balvig/capistrano-fiesta.git', last_release: '20151009145023')
      end
  end
end
