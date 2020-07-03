$stdout.sync = true
$stderr.sync = true

require 'rack'
use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

Signal.trap('TERM') {
  $stdout.puts('Goodbye from puller server')
  exit(0)
}

require_relative 'code/externals'
require_relative 'code/puller'
require_relative 'code/rack_dispatcher'
externals = Externals.new({})
puller = Puller.new(externals)
dispatcher = RackDispatcher.new(puller, Rack::Request)
run dispatcher
