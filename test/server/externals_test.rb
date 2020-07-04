# frozen_string_literal: true
require_relative 'puller_test_base'

class ExternalsTest < PullerTestBase

  def self.id58_prefix
    '7A9'
  end

  test '921',
  %w( default http is Net::HTTP ) do
    assert_equal 'Net::HTTP', externals.http.name
  end

end
