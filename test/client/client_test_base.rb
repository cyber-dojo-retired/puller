require_relative '../id58_test_base'
require_src 'externals'
require_src 'runner'

class ClientTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def runner
    @runner ||= Runner.new(externals)
  end

end
