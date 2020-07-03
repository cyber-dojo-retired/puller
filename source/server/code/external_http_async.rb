# frozen_string_literal: true
require 'httpray' # https://github.com/gworley3/httpray
require 'json'

class ExternalHttpAsync

  def initialize(_externals, options = {})
    @options = options
    @options[:timeout] ||= 0.2
  end

  def post(hostname, port, path, body)
    # fire-and-forget http call
    HTTPray.request(
      'POST',
      "http://#{hostname}:#{port}/#{path}",
      { 'Content-Type' => 'application/json' },
      body.to_json,
      @options[:timeout]
    )
  rescue HTTPray::Timeout
    # TODO: log
  end

end
