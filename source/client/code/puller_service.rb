require_relative 'http_json/request_packer'
require_relative 'http_json/response_unpacker'
require_relative 'puller_exception'

class PullerService

  def initialize(externals)
    requester = HttpJson::RequestPacker.new(externals.http, 'puller-server', 5017)
    @http = HttpJson::ResponseUnpacker.new(requester, PullerException)
  end

  # - - - - - - - - - - - - - - - - - -

  def sha
    @http.get(__method__, {})
  end

  def alive?
    @http.get(__method__, {})
  end

  def ready?
    @http.get(__method__, {})
  end

  # - - - - - - - - - - - - - - - - - -

  def async_pull_images(id, image_name)
    @http.post(__method__, {
      id:id,
      image_name:image_name
    })
  end

  # - - - - - - - - - - - - - - - - - -

  def async_pull_image(id, image_name, ip_address)
    @http.post(__method__, {
      id:id,
      image_name:image_name,
      ip_address:ip_address
    })
  end

end
