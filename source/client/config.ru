$stdout.sync = true
$stderr.sync = true

require_relative 'code/externals'
require_relative 'code/puller_http_proxy'
require_relative 'code/rack_dispatcher'

Signal.trap('TERM') {
  $stdout.puts('Goodbye from puller client')
  exit(0)
}

externals = Externals.new
puller = PullerHttpProxy.new(externals)
run RackDispatcher.new(puller)
