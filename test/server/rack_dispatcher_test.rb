require_relative 'puller_test_base'
require_relative 'rack_request_stub'
require_source 'rack_dispatcher'

class RackDispatcherTest < PullerTestBase

  def self.id58_prefix
    '4AF'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # 200
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '130', %w(
  allow empty body instead of {} which is
  useful for kubernetes live/ready probes ) do
    response = rack_call('ready', '')
    assert_equal 200, response[0]
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    assert_equal({"ready?" => true}, JSON.parse(response[2][0]))
  end

  test '131', 'sha 200' do
    args = {}
    assert_200('sha', args) do |response|
      assert_equal ENV['SHA'], response['sha']
    end
  end

  test '132', 'alive 200' do
    args = {}
    assert_200('alive', args) do |response|
      assert_equal true, response['alive?']
    end
  end

  test '133', 'ready 200' do
    args = {}
    assert_200('ready', args) do |response|
      assert_equal true, response['ready?']
    end
  end

  test '135', 'async_pull_images 200' do
    http = ExternalHttpAsyncSpy.new
    externals(http_async:http)
    args = { id:id58, image_name:gcc_assert }
    assert_200('async_pull_images', args) do |response|
      assert_nil response['async_pull_images']
    end
  end

  test '136', 'async_pull_image 200' do
    http = ExternalHttpAsyncSpy.new
    externals(http_async:http)
    args = { id:id58, image_name:gcc_assert, ip_address:'10.3.5.67' }
    assert_200('async_pull_image', args) do |response|
      assert_nil response['async_pull_image']
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # 400
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E20',
  'dispatch returns 400 status when body is not JSON' do
    assert_dispatch_error('xyz', '123', 400, 'body is not JSON Hash')
  end

  test 'E21',
  'dispatch returns 400 status when body is not JSON Hash' do
    assert_dispatch_error('xyz', [].to_json, 400, 'body is not JSON Hash')
  end

  test 'E22',
  'dispatch returns 400 when method name is unknown' do
    assert_dispatch_error('xyz', {}.to_json, 400, 'unknown path')
  end

  test 'E23',
  'dispatch returns 400 when one arg is unknown' do
    assert_dispatch_error('sha',   {x:42}.to_json, 400, 'unknown argument: :x')
    assert_dispatch_error('alive', {y:42}.to_json, 400, 'unknown argument: :y')
    assert_dispatch_error('ready', {z:42}.to_json, 400, 'unknown argument: :z')
  end

  test 'E24',
  'dispatch returns 400 when two or more args are unknown' do
    assert_dispatch_error('sha',   {x:4,y:2}.to_json, 400, 'unknown arguments: :x, :y')
    assert_dispatch_error('alive', {y:4,a:2}.to_json, 400, 'unknown arguments: :y, :a')
    assert_dispatch_error('ready', {z:4,b:2}.to_json, 400, 'unknown arguments: :z, :b')
  end

  test 'E27',
  %w( async_pull_images returns 400 when id is missing ) do
    args = { image_name:gcc_assert }.to_json
    assert_dispatch_error('async_pull_images', args, 400, 'missing argument: :id')
  end

  test 'E28',
  %w( async_pull_images returns 400 when image_name is missing ) do
    args = { id:id58 }.to_json
    assert_dispatch_error('async_pull_images', args, 400, 'missing argument: :image_name')
  end

  test 'E29',
  %w( async_pull_image returns 400 when id is missing ) do
    args = { image_name:gcc_assert, ip_address:'10.4.5.6' }.to_json
    assert_dispatch_error('async_pull_image', args, 400, 'missing argument: :id')
  end

  test 'E30',
  %w( async_pull_image returns 400 when image_name is missing ) do
    args = { id:id58, ip_address:'10.4.5.6' }.to_json
    assert_dispatch_error('async_pull_image', args, 400, 'missing argument: :image_name')
  end

  test 'E31',
  %w( async_pull_image returns 400 when ip_address is missing ) do
    args = { id:id58, image_name:gcc_assert }.to_json
    assert_dispatch_error('async_pull_image', args, 400, 'missing argument: :ip_address')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # 500
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  class ShaRaiser
    def initialize(*args)
      @klass = args[0]
      @message = args[1]
    end
    def sha
      raise @klass, @message
    end
  end

  test 'F1A',
  'dispatch returns 500 status when implementation raises' do
    @puller = ShaRaiser.new(ArgumentError, 'wibble')
    assert_dispatch_error('sha', {}.to_json, 500, 'wibble')
  end

  test 'F1B',
  'dispatch returns 500 status when implementation has syntax error' do
    @puller = ShaRaiser.new(SyntaxError, 'fubar')
    assert_dispatch_error('sha', {}.to_json, 500, 'fubar')
  end

  private

  def assert_200(name, args)
    response = rack_call(name, args.to_json)
    assert_equal 200, response[0]
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    yield JSON.parse(response[2][0])
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_dispatch_error(name, args, status, message)
    response,stderr = with_captured_stderr { rack_call(name, args) }
    assert_equal status, response[0], "message:#{message},stderr:#{stderr}"
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    assert_json_exception(response[2][0], name, args, message)
    assert_json_exception(stderr,         name, args, message)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_json_exception(s, name, body, message)
    json = JSON.parse!(s)
    exception = json['exception']
    refute_nil exception
    diagnostic = "path:#{__LINE__}"
    assert_equal '/'+name, exception['path'], diagnostic
    diagnostic = "body:#{__LINE__}"
    assert_equal body, exception['body'], diagnostic
    diagnostic = "exception['class']:#{__LINE__}"
    assert_equal 'Puller', exception['class'], diagnostic
    diagnostic = "exception['message']:#{__LINE__}"
    assert_equal message, exception['message'], diagnostic
    diagnostic = "exception['backtrace'].class.name:#{__LINE__}"
    assert_equal 'Array', exception['backtrace'].class.name, diagnostic
    diagnostic = "exception['backtrace'][0].class.name:#{__LINE__}"
    assert_equal 'String', exception['backtrace'][0].class.name, diagnostic
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def rack_call(name, args)
    @puller ||= Puller.new(externals)
    rack = RackDispatcher.new(@puller, RackRequestStub)
    env = { path_info:name, body:args }
    rack.call(env)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def with_captured_stderr
    old_stderr = $stderr
    $stderr = StringIO.new('', 'w')
    response = yield
    return [ response, $stderr.string ]
  ensure
    $stderr = old_stderr
  end

end
