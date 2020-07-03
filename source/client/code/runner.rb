require_relative 'http_json/request_error'
require_relative 'http_json_args'
require 'json'
require 'rack'

class Runner

  # This is not right...this is a rack-dispatcher
  # This needs mimic a runner and have its own
  # ready?
  # pull_images()
  # run_cyber_dojo_sh()

  def initialize(runner_set)
    @runner_set = runner_set
  end

  def call(env)
    request = Rack::Request.new(env)
    path = request.path_info
    name,args = HttpJsonArgs.new.get(path)
    result = @runner_set.public_send(name, *args)
    json_response_success({ name => result })
  rescue HttpJson::RequestError => error
    json_response_failure(400, path, error)
  rescue Exception => error
    json_response_failure(500, path, error)
  end

  private

  def json_response_success(json)
    body = JSON.fast_generate(json)
    json_response(200, body)
  end

  def json_response_failure(status, path, error)
    json = diagnostic(path, error)
    body = JSON.pretty_generate(json)
    $stderr.puts(body)
    json_response(status, body)
  end

  def json_response(status, json)
    [ status,
      { 'Content-Type' => 'application/json' },
      [ body ]
    ]
  end

  # - - - - - - - - - - - - - - - -

  def diagnostic(path, error)
    { 'exception' => {
        'path' => path,
        'class' => 'RunnerSet',
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    }
  end

end
