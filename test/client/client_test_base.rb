require_relative '../id58_test_base'
require_source 'externals'

class ClientTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def puller
    externals.puller
  end

end
