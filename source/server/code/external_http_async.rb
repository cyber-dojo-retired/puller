# frozen_string_literal: true
require 'json'

class ExternalHttpAsync

  def initialize(_externals, options = {})
    @options = options
    @options[:timeout] ||= 1
  end


  def post(hostname, port, path, body)
    # Using plain curl and backgrounded bash call.
    url = "http://#{hostname}:#{port}/#{path}"
    json = JSON.dump(body)

    command = [
      'curl',
      "--data '#{json}'",
      "--header 'Content-type: application/json'",
      "--header 'Accept: application/json'",
      "--request 'POST'",
      "--silent",
      url
    ].join(' ') + ' &'
    `#{command}`
  end

end

=begin
  # https://github.com/Kong/unirest-ruby

  def raw_post(hostname, port, path, body)
    # https://gist.github.com/gonzalocasas/9a2382c377a60e44271d2d610992d7a7
    url = "http://#{hostname}:#{port}/#{path}"
    uri = URI.parse(url)
    json = JSON.dump(body)

    puts "POST #{uri.request_uri} HTTP/1.1"
    puts "Host: #{uri.host}:#{port}"

    req = []
    req << "POST #{uri.request_uri} HTTP/1.1"
    req << "Host: #{uri.host}:#{port}"

    req << 'Accept: */*'
    req << 'Connection: Close'
    req << 'Content-Type: application/json'
    req << "Content-Length: #{json.bytesize}"
    req << 'User-Agent: fire-and-forget'
    crlf = "\r\n"

    socket = TCPSocket.open(uri.host, uri.port)
    req.each { |part| socket.puts(part + crlf) }
    socket.puts(crlf)
    socket.puts(json)
  ensure
    socket.close if socket
  end


  def httpray_post(hostname, port, path, body)
    # Cant get this to work...
    # fire-and-forget http call
    uri = "http://#{hostname}:#{port}/#{path}"
    headers = {
      'Content-type' => 'application/json'
      #'Accept' => 'application/json'
    }
    json = JSON.dump(body)
    puts "HTTPray.request('POST',\"#{uri}\",#{headers},#{json})"

    HTTPray.request(
      'POST',
      uri,
      headers,
      json,
      @options[:timeout]
    )
  rescue HTTPray::Timeout => error
    puts error.class.name
    puts error.message
    # TODO: log
  end

=end
