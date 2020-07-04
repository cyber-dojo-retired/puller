# frozen_string_literal: true
require_relative 'puller_test_base'
require_relative 'external_http_sync_spy'
require 'uri'

class PullImagesTest < PullerTestBase

  def self.id58_prefix
    '37f'
  end

  # - - - - - - - - - - - - - - - - -

  test 'aB0', %w(
  pull_images() make 16 synchronous http calls to hostname runner
  ) do
    http = ExternalHttpSyncSpy.new('pull_image')
    externals(http:http)
    puller.pull_images(id:id58, image_name:gcc_assert)
    16.times do |i|
      spied = http.spied[i]
      assert_equal URI.parse('http://runner:4597/pull_image'), spied[:uri], :uri
      assert_equal 'application/json', spied[:request]['content_type'], :content_type
      expected_body = { 'id' => id58+"-#{i}", 'image_name' => gcc_assert }
      actual_body = JSON.parse!(spied[:request]['body'])
      assert_equal expected_body, actual_body, :body
    end
  end

end
