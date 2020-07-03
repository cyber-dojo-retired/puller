# frozen_string_literal: true
require_relative '../id58_test_base'
require_source 'externals'
require_source 'puller'

class PullerTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def puller
    @puller ||= Puller.new(externals)
  end

  def externals(options = {})
    @externals ||= Externals.new(options)
  end

  # - - - - - - - - - - - - - - - - -

  def gcc_assert
    'cyberdojofoundation/gcc_assert:93eefc6'
  end

end
