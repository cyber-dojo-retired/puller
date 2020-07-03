require_relative '../id58_test_base'
require_src 'externals'
require_src 'runner_set_service'

class ClientTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def runner_set
    @runner_set ||= RunnerSetService.new(externals)
  end

end
