require_relative 'client_test_base'

class RunnerSetClientTest < ClientTestBase

  def self.id58_prefix
    '200'
  end

  # - - - - - - - - - - - - - - - - - - - -
  # failure cases
  # - - - - - - - - - - - - - - - - - - - -

  test '7C0', %w( calling unknown method raises ) do
    requester = HttpJson::RequestPacker.new(externals.http, 'runner-set-server', 4599)
    http = HttpJson::ResponseUnpacker.new(requester, RunnerSetException)
    error = assert_raises(RunnerSetException) { http.get(:shar, {"x":42}) }
    json = JSON.parse(error.message)
    assert_equal '/shar', json['path']
    assert_equal '{"x":42}', json['body']
    assert_equal 'RunnerSetService', json['class']
    assert_equal 'unknown path', json['message']
  end

end
