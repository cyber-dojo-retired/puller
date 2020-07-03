# frozen_string_literal: true
require 'net/http'

class ExternalHttpSync

  def initialize(_externals, options = {})
    @options = options
    @options[:open_timeout] ||= 1
  end

  def post(uri)
    Net::HTTP::Post.new(uri)
  end

  def start(hostname, port, req)
    Net::HTTP.start(hostname, port, @options) do |http|
      http.request(req)
    end
  end

end
