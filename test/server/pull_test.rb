# frozen_string_literal: true
require_relative 'puller_test_base'
require_relative 'external_http_async_spy'

class PullTest < PullerTestBase

  def self.id58_prefix
    '37f'
  end

  # - - - - - - - - - - - - - - - - -

  test 'aB0', %w(
  async_pull_images() make 16 http async calls to hostname runner
  ) do
    http = ExternalHttpAsyncSpy.new
    externals(http_async:http)
    puller.async_pull_images(id:id58, image_name:gcc_assert)
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

  # - - - - - - - - - - - - - - - - -

  test 'aB1', %w(
  async_pull_image() makes 1 http async call to give ip-address
  ) do
    http = ExternalHttpAsyncSpy.new
    externals(http_async:http)
    puller.async_pull_image(id:id58, image_name:gcc_assert, ip_address:'10.4.5.6')
    spied = http.spied[0]
    assert_equal '10.4.5.6', spied[:hostname], :hostname
    assert_equal 4597, spied[:port], :port
    assert_equal 'pull_image', spied[:path], :path
    expected_body = { id:id58, image_name:gcc_assert }
    actual_body = spied[:body]
    assert_equal expected_body, actual_body, :body
  end

end
