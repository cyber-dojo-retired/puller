# frozen_string_literal: true
require_relative 'http_json_args'
require 'json'
require 'rack'

class RackDispatcher

  def initialize(runner)
    @dispatcher = HttpJsonArgs.new(runner)
  end

  def call(env)
    request = Rack::Request.new(env)
    path = request.path_info
    body = request.body.read
    result = @dispatcher.get(path, body)
    json_response_success(result)
  rescue HttpJsonArgs::RequestError => error
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

  def json_response(status, body)
    [ status,
      { 'Content-Type' => 'application/json' },
      [ body ]
    ]
  end

  def diagnostic(path, error)
    { 'exception' => {
        'path' => path,
        'class' => 'Runner',
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    }
  end

end
