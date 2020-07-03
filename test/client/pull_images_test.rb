require_relative 'client_test_base'

class PullImagesTest < ClientTestBase

  def self.id58_prefix
    'qU6'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'kH6', %w(
  when runner (client) calls puller.async_pull_images()
  then it returns immediately (as its async),
  puller makes 16 async http calls to all runners,
  runner-client is the only runner, so it receives all 16 calls,
  which write to /tmp
  ) do
    puller.pull_images(id58, gcc_assert)
    #TODO
  end

  # TODO
  # puller.pull_images(id58, gcc_assert, my_ip_address)
  # ...

  private

  #def my_ip_address
  #  `hostname -i`.strip
  #end

  def gcc_assert
    'cyberdojofoundation/gcc_assert:93eefc6'
  end

end
