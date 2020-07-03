$stdout.sync = true
$stderr.sync = true

require_relative 'code/externals'
require_relative 'code/rack_dispatcher'
require_relative 'code/runner'

Signal.trap('TERM') {
  $stdout.puts('Goodbye from puller client')
  exit(0)
}

externals = Externals.new
runner = Runner.new(externals)
run RackDispatcher.new(runner)
