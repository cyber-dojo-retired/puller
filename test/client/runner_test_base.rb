# frozen_string_literal: true
require_relative '../id58_test_base'
require_relative 'puller_http_proxy'
require 'net/http'

class RunnerTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def http
    @http ||= Net::HTTP
  end

  def puller
    @puller ||= PullerHttpProxy.new(self)
  end

end
