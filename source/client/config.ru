$stdout.sync = true
$stderr.sync = true

require_relative 'code/runner'
require_relative 'code/runner_set_service'
require_relative 'code/externals'
require 'rack'

Signal.trap('TERM') {
  $stdout.puts('Goodbye from puller client')
  exit(0)
}

externals = Externals.new
runner_set = RunnerSetService.new(externals)
run Runner.new(runner_set)
