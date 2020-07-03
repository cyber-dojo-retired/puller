# frozen_string_literal: true
require 'httpray' # https://github.com/gworley3/httpray
require 'json'

class ExternalHttpAsync

  def initialize(_externals, options = {})
    @options = options
    @options[:timeout] ||= 1
  end

  def post(hostname, port, path, body)
    # fire-and-forget http call
    uri = "http://#{hostname}:#{port}/#{path}"
    content_type = { 'Content-Type' => 'application/json' }

    puts "HTTPray.request('POST',\"#{uri}\",#{content_type},#{body.to_json})"

    HTTPray.request(
      'POST',
      uri,
      content_type,
      body.to_json,
      @options[:timeout]
    )
  rescue HTTPray::Timeout => error
    puts error.class.name
    puts error.message
    # TODO: log
  end

end
