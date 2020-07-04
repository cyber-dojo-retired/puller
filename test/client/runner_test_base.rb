# frozen_string_literal: true
require_relative '../id58_test_base'
require_relative 'puller_http_proxy'
require_source 'externals'
require_source 'runner'

class RunnerTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def runner
    # Client is pretending to be a runner-client.
    @runner ||= Runner.new(externals)
  end

  def puller
    # Tests make calls to puller-server, which
    # calls back into the runner-client.
    @puller ||= PullerHttpProxy.new(self)
  end

  def http
    @http ||= Net::HTTP
  end

end
