# frozen_string_literal: true
require_relative 'http_json/request_packer'
require_relative 'http_json/response_unpacker'
require_relative 'http_json/exception'

class RunnerHttpProxy

  class Exception < HttpJson::Exception
    def initialize(message)
      super
    end
  end

  def initialize(externals, hostname)
    requester = HttpJson::RequestPacker.new(externals.http, hostname, 4597)
    @http = HttpJson::ResponseUnpacker.new(requester, Exception)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def pull_image(id, image_name)
    @http.post(__method__, {
      id:id,
      image_name:image_name
    })
  end

end
