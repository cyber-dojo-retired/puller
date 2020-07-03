# frozen_string_literal: true
require_relative 'puller_test_base'
require_source 'http_json_args'

class HttpJsonArgsTest < PullerTestBase

  def self.id58_prefix
    'EE7'
  end

  # - - - - - - - - - - - - - - - - -
  # dispatch calls with correct number of args
  # return hash with single key matching the path
  # - - - - - - - - - - - - - - - - -

  test 'e11', %w( unknown path raises ) do
    expected = 'unknown path'
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch('/emmerdale', puller, '{}')
    }
    assert_equal expected, error.message
  end

  test 'e12', '/sha has no args' do
    result = dispatch('/sha', puller, '{}')
    assert_equal ['sha'], result.keys
  end

  test 'e13', '/alive has no args' do
    result = dispatch('/alive', puller, '{}')
    assert_equal({'alive?' => true }, result)
  end

  test 'e14', '/ready has no args' do
    result = dispatch('/ready', puller, '{}')
    assert_equal({ 'ready?' => true }, result)
  end

  test 'e16', %w(
  /async_pull_images has 2 keyword args, id: image_name:
  ) do
    http = ExternalHttpAsyncSpy.new
    externals(http_async:http)
    body = { id:id58, image_name:gcc_assert }.to_json
    result = dispatch('/async_pull_images', puller, body)
    assert_equal ['async_pull_images'], result.keys
  end

  test 'e17', %w(
  /async_pull_image has 3 keyword args, id: image_name: ip_address:
  ) do
    http = ExternalHttpAsyncSpy.new
    externals(http_async:http)
    body = { id:id58, image_name:gcc_assert, ip_address:'10.2.5.78' }.to_json
    result = dispatch('/async_pull_image', puller, body)
    assert_equal ['async_pull_image'], result.keys
  end

  # - - - - - - - - - - - - - - - - -

  test 'A04', %w( dispatch raises when body string is invalid json ) do
    expected = 'body is not JSON'
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch(nil,nil,'abc')
    }
    assert_equal expected, error.message
  end

  test 'A05', %w( nil is null in json ) do
    expected = 'body is not JSON'
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch(nil,nil,'{"x":nil}')
    }
    assert_equal expected, error.message
  end

  test 'A06', %w( keys have to be strings in incoming json ) do
    expected = 'body is not JSON'
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch(nil,nil,'{42:"answer"}')
    }
    assert_equal expected, error.message
  end

  test 'A07', %w( body has to be a hash ) do
    expected = 'body is not JSON Hash'
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch(nil,nil,'[]')
    }
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - -

  test '7B2',
  %w( async_pull_images() missing id raises HttpJsonArgs::RequestError ) do
    body = { image_name:gcc_assert }.to_json
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch('/async_pull_images', puller, body)
    }
    assert_equal 'missing argument: :id', error.message
  end

  test '7B3',
  %w( async_pull_images() missing image_name raises HttpJsonArgs::RequestError ) do
    body = { id:id58 }.to_json
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch('/async_pull_images', puller, body)
    }
    assert_equal 'missing argument: :image_name', error.message
  end

  test '7B4',
  %w( async_pull_image() missing id raises HttpJsonArgs::RequestError ) do
    body = { image_name:gcc_assert, ip_address:'10.4.6.87' }.to_json
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch('/async_pull_image', puller, body)
    }
    assert_equal 'missing argument: :id', error.message
  end

  test '7B5',
  %w( async_pull_image() missing image_name raises HttpJsonArgs::RequestError ) do
    body = { id:id58, ip_address:'10.4.6.87' }.to_json
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch('/async_pull_image', puller, body)
    }
    assert_equal 'missing argument: :image_name', error.message
  end

  test '7B6',
  %w( async_pull_image() missing ip_address raises HttpJsonArgs::RequestError ) do
    body = { id:id58, image_name:gcc_assert }.to_json
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch('/async_pull_image', puller, body)
    }
    assert_equal 'missing argument: :ip_address', error.message
  end

  # - - - - - - - - - - - - - - - - -
  # dispatch calls with one unknown argument
  # raise HttpJsonArgs::RequestError
  # - - - - - - - - - - - - - - - - -

  test 'c51',
  %w( sha() unknown arg raises HttpJsonArgs::RequestError ) do
    assert_unknown_arg('/sha', {bad:21}, 'bad')
  end

  test 'c52',
  %w( alive?() unknown arg raises HttpJsonArgs::RequestError ) do
    assert_unknown_arg('/alive', {none:'sd'}, 'none')
  end

  test 'c53',
  %w( ready?() unknown arg raises HttpJsonArgs::RequestError ) do
    assert_unknown_arg('/ready', {flag:true}, 'flag')
  end

  test 'c55',
  %w( async_pull_images() unknown arg raises HttpJsonArgs::RequestError ) do
    body = {
      id:id58,
      image_name:gcc_assert,
      whiskey:nil # unknown
    }
    assert_unknown_arg('/async_pull_images', body, 'whiskey')
  end

  test 'c56',
  %w( async_pull_image() unknown arg raises HttpJsonArgs::RequestError ) do
    body = {
      id:id58,
      image_name:gcc_assert,
      ip_address:'10.5.6.23',
      whiskey:nil # unknown
    }
    assert_unknown_arg('/async_pull_image', body, 'whiskey')
  end

  # - - - - - - - - - - - - - - - - -
  # dispatch calls with more than one unknown argument
  # raise HttpJsonArgs::RequestError
  # - - - - - - - - - - - - - - - - -

  test 'd51',
  %w( sha() extra unknown args raises HttpJsonArgs::RequestError ) do
    assert_unknown_args('/sha', {xxx:true, bad:21}, 'xxx', 'bad')
  end

  test 'd52',
  %w( alive?() extra unknown args raises HttpJsonArgs::RequestError ) do
    assert_unknown_args('/alive', {none:'sd', z:nil}, 'none', 'z')
  end

  test 'd53',
  %w( ready?() extra unknown args raises HttpJsonArgs::RequestError ) do
    assert_unknown_args('/ready', {flag:true,a:'dfg'}, 'flag', 'a')
  end

  test 'd55',
  %w( async_pull_images() extra unknown args raises HttpJsonArgs::RequestError ) do
    body = {
      id:id58,
      image_name:gcc_assert,
      flag:true, # unknown
      a:'dfg'    # unknown
    }
    assert_unknown_args('/async_pull_images', body, 'flag', 'a')
  end

  test 'd56',
  %w( async_pull_image() extra unknown args raises HttpJsonArgs::RequestError ) do
    body = {
      id:id58,
      image_name:gcc_assert,
      ip_address:'10.56.7.23',
      flaggon:true, # unknown
      abc:'dfg'    # unknown
    }
    assert_unknown_args('/async_pull_image', body, 'flaggon', 'abc')
  end

  private

  def dispatch(path, puller, body)
    HttpJsonArgs::dispatch(path, puller, body)
  end

  # - - - - - - - - - - - - - - - - -

  def assert_unknown_arg(path, args, name)
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch(path, puller, args.to_json)
    }
    assert_equal "unknown argument: :#{name}", error.message
  end

  # - - - - - - - - - - - - - - - - -

  def assert_unknown_args(path, args, *names)
    error = assert_raises(HttpJsonArgs::RequestError) {
      dispatch(path, puller, args.to_json)
    }
    names.map!{ |name| ':'+name }
    assert_equal "unknown arguments: #{names.join(', ')}", error.message
  end

end
