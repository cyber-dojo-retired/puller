require_relative 'runner_test_base'

class PullImagesTest < RunnerTestBase

  def self.id58_prefix
    'qU6'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'kH6', %w(
  when anyone calls puller.pull_images() it makes 16 synchronous http calls to hostname='runner',
  any runner responding to this by actually pulling the image
  must pull in a detached-fork so the original caller (who is creating a new session)
  gets the 6-character id back in a timely fashion, and can proceed to their kata;
  In this test, runner-client (us) is the only runner, so we receive all 16 calls,
  one of which simulates pulling the image
  ) do
    puller.pull_images(id58, gcc_assert)
    #TODO
  end

  private

  def gcc_assert
    'cyberdojofoundation/gcc_assert:93eefc6'
  end

end
