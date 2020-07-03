# frozen_string_literal: true
require_relative 'runner_set_test_base'
require_relative 'external_http_sync_spy'
require_relative 'external_sampler_stub'
require_relative 'external_time_stub'

class RunCyberDojoShTest < RunnerSetTestBase

  def self.id58_prefix
    '9c2'
  end

  def id58_setup
    @http = ExternalHttpSyncSpy.new('run_cyber_dojo_sh')
    @sampler = ExternalSamplerStub.new
    @time = ExternalTimeStub.new
    @t0 = Time.mktime(2020,3,5, 13,14,15)
    externals(http_sync:@http, sampler:@sampler, time:@time)
  end

  attr_reader :t0

  # - - - - - - - - - - - - - - - - -

  test '4d0', %w(
  given there are NO ip-addresses,
  when run_cyber_dojo_sh() is called,
  then fall back to using runner hostname
  ) do
    run_cyber_dojo_sh(id, files, manifest, t0)
    assert_requested_http_run_cyber_dojo_sh('runner', id, files, manifest)
  end

  # - - - - - - - - - - - - - - - - -

  test '4d1', %w(
  given there is one UN-EXPIRED ip-address,
  when run_cyber_dojo_sh() is called,
  then one outgoing http call is made to that ip-address
  ) do
    ip_address = '10.16.1.55'
    heartbeat(ip_address, t0)
    sampler_stub(ip_address)
    run_cyber_dojo_sh(id, files, manifest, t0)
    assert_requested_http_run_cyber_dojo_sh(ip_address, id, files, manifest)
  end

  # - - - - - - - - - - - - - - - - -

  test '4d2', %w(
  given there is one EXPIRED ip-address,
  when run_cyber_dojo_sh() is called,
  then fall back to using runner hostname
  ) do
    ip_address = '10.16.2.55'
    heartbeat(ip_address, t0)
    run_cyber_dojo_sh(id, files, manifest, t0 + seconds_until_hearbeat_expires + 1)
    assert_requested_http_run_cyber_dojo_sh('runner', id, files, manifest)
  end

  # - - - - - - - - - - - - - - - - -

  test '4d3', %w(
  given there is one expired ip-address,
  when heartbeat() is called to RENEW it,
  and run_cyber_dojo_sh() is then called,
  then one outgoing http call is made to that ip-address
  ) do
    ip_address = '10.16.3.55'
    heartbeat(ip_address, t0)
    heartbeat(ip_address, t0 + seconds_until_hearbeat_expires - 1)
    sampler_stub(ip_address)
    run_cyber_dojo_sh(id, files, manifest, t0 + seconds_until_hearbeat_expires + 1)
    assert_requested_http_run_cyber_dojo_sh(ip_address, id, files, manifest)
  end

  # - - - - - - - - - - - - - - - - -

  test '4d4', %w(
  given there are more than one UN-EXPIRED ip-address,
  when run_cyber_dojo_sh() is called,
  then one outgoing http call is made to a random selected ip-address
  ) do
    ip_address_1 = '10.16.4.67'
    ip_address_2 = '10.16.4.68'
    heartbeat(ip_address_1, t0)
    heartbeat(ip_address_2, t0 + 1)
    sampler_stub(ip_address_1)
    run_cyber_dojo_sh(id, files, manifest, t0 + 2)
    assert_requested_http_run_cyber_dojo_sh(ip_address_1, id, files, manifest)
    sampler_stub(ip_address_2)
    run_cyber_dojo_sh(id, files, manifest, t0 + 3)
    assert_requested_http_run_cyber_dojo_sh(ip_address_2, id, files, manifest)
  end

  private

  def id
    id58
  end

  def files
    { 'hiker.rb' => 'ssdfsdf' }
  end

  def manifest
    { 'image_name' => gcc_assert }
  end

  # - - - - - - - - - - - - - - - - -

  def sampler_stub(ip_address)
    @sampler.stub(ip_address)
  end

  # - - - - - - - - - - - - - - - - -

  def run_cyber_dojo_sh(id, files, manifest, now)
    @http.clear
    @time.stub(now)
    runner_set.run_cyber_dojo_sh(
      id:id,
      files:files,
      manifest:manifest
    )
  end

  # - - - - - - - - - - - - - - - - -

  def assert_requested_http_run_cyber_dojo_sh(ip_address, id, files, manifest)
    spied = @http.spied[0]
    assert_equal '/run_cyber_dojo_sh', spied[:uri].request_uri, :path
    assert_equal ip_address, spied[:hostname], :hostname
    assert_equal 4597, spied[:port], :port
    body = JSON.parse!(spied[:request].body)
    assert_equal id, body['id'], :id
    assert_equal files, body['files'], :files
    assert_equal manifest, body['manifest'], :manifest
  end

end
