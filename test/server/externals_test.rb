# frozen_string_literal: true
require_relative 'puller_test_base'

class ExternalsTest < PullerTestBase

  def self.id58_prefix
    '7A9'
  end

  test '921',
  %w( default http_async is ExternalHttpAsync ) do
    assert externals.http_async.is_a?(ExternalHttpAsync)
  end

end
