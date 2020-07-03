require_relative 'client_test_base'

class PullImagesTest < ClientTestBase

  def self.id58_prefix
    'qU6'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'kH6', %w(
  runner calls runner-set heartbeat to register its ip-address,
  which returns the number of seconds till the ip-address expires
  ) do
    assert_equal 4, my_ip_address.split('.').size
    response = runner_set.heartbeat(my_ip_address)
    assert_equal 30, response
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'kH7', %w(
  ) do
    runner_set.heartbeat(my_ip_address)
    runner_set.pull_images(id58, server_deployment, [gcc_assert])
    # Now to implement pull_images in the web-server
    # in such a way that we can verify it happened.
  end

  private

  def my_ip_address
    `hostname -i`.strip
  end

  def server_deployment
    'SERVER_DEPLOYMENT'
  end

  #def session_start
  #  'SESSION_START'
  #end

  def gcc_assert
    'cyberdojofoundation/gcc_assert:93eefc6'
  end

end
