require_relative 'puller_http_proxy'
require 'net/http'

class Externals

  def http
    @http ||= Net::HTTP
  end

  def puller
    @puller ||= PullerHttpProxy.new(self)
  end

end
