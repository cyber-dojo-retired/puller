$stdout.sync = true
$stderr.sync = true

require_relative 'code/puller'
require_relative 'code/puller_service'
require_relative 'code/externals'
require 'rack'

Signal.trap('TERM') {
  $stdout.puts('Goodbye from puller client')
  exit(0)
}

externals = Externals.new
ps = PullerService.new(externals)
run Puller.new(ps)
