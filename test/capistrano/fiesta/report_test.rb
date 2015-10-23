require 'test_helper'

module Capistrano::Fiesta
  class ReportTest < Minitest::Test
    def test_write
      query = "base:master repo:balvig/capistrano-fiesta merged:>2015-10-09T14:50:23Z"
      response = { items: [{ title: "New login [Delivers #123]", body: "" }] }
      github = stub_request(:get, "https://api.github.com:443/search/issues").with(query: { q: query }).to_return_json(response)

      output = <<-OUTPUT
• New login
      OUTPUT
      Kernel.stub :system, true do
        assert_equal output, report.write
        assert_requested github
      end
    end

    def test_no_new_stories
      response = { items: [] }
      github = stub_request(:get, /github.com/).to_return_json(response)
      assert true, report.write.nil?
      assert_requested github
    end

    private

      def report
        Report.new('git@github.com:balvig/capistrano-fiesta.git', last_release: '20151009145023')
      end
  end
end
