require_relative 'client_test_base'

class ProbeTest < ClientTestBase

  def self.id58_prefix
    '89s'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '946', 'alive? 200' do
    assert puller.alive?
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '947', 'ready? 200' do
    assert puller.ready?
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '945', 'sha 200' do
    sha = puller.sha
    assert_equal 40, sha.size, 'sha.size'
    sha.each_char do |ch|
      assert '0123456789abcdef'.include?(ch), ch
    end
  end

end
