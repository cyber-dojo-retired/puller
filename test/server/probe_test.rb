# frozen_string_literal: true
require_relative 'puller_test_base'

class AliveTest < PullerTestBase

  def self.id58_prefix
    '19q'
  end

  # - - - - - - - - - - - - - - - - -

  test '93b', %w(
  puller is alive
  ) do
    expected = { 'alive?' => true }
    assert_equal expected, puller.alive?
  end

  # - - - - - - - - - - - - - - - - -

  test '102', %w(
  puller is ready
  ) do
    expected = { 'ready?' => true }
    assert expected, puller.ready?
  end

  # - - - - - - - - - - - - - - - - -

  test '4d1', %w(
  puller's sha the 40-char commit sha of image
  ) do
    sha = puller.sha['sha']
    assert_equal 40, sha.size
    sha.each_char do |ch|
      assert "0123456789abcdef".include?(ch)
    end
  end

end
