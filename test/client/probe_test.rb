require_relative 'runner_test_base'

class ProbeTest < RunnerTestBase

  def self.id58_prefix
    '89s'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '946', 'alive? 200' do
    expected = { 'alive?' => true }
    actual = runner.alive?
    assert_equal expected, actual
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '947', 'ready? 200' do
    expected = { 'ready?' => true }
    actual = runner.ready?
    assert_equal expected, actual
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '945', 'sha 200' do
    hash = runner.sha
    assert_equal ['sha'], hash.keys
    sha = hash['sha']
    assert_equal 40, sha.size, 'sha.size'
    sha.each_char do |ch|
      assert '0123456789abcdef'.include?(ch), ch
    end
  end

end
