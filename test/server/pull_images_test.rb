# frozen_string_literal: true
require_relative 'puller_test_base'
require_relative 'external_http_sync_spy'

class PullImagesTest < PullerTestBase

  def self.id58_prefix
    '37f'
  end

  # - - - - - - - - - - - - - - - - -

=begin TODO
  test 'aB0', %w(
  pull_images() make 16 synchronous http calls to hostname runner
  ) do
    http = ExternalHttpSyncSpy.new('pull_images')
    externals(http:http)
    puller.pull_images(id:id58, image_name:gcc_assert)
    16.times do |i|
      spied = http.spied[i]
      assert_equal 'runner', spied[:hostname], :hostname
      assert_equal 4597, spied[:port], :port
      assert_equal 'pull_image', spied[:path], :path
      expected_body = { id:id58+"-#{i}", image_name:gcc_assert }
      actual_body = spied[:body]
      assert_equal expected_body, actual_body, :body
    end
  end
=end

end
