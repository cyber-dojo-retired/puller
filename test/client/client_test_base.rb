require_relative '../id58_test_base'
require_src 'externals'
require_src 'puller_http_proxy'

class ClientTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def puller
    @puller ||= PullerHttpProxy.new(externals)
  end

end
