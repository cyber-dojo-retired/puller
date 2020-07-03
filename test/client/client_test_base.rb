require_relative '../id58_test_base'
require_src 'externals'
require_src 'puller_service'

class ClientTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def puller
    @puller ||= PullerService.new(externals)
  end

end
