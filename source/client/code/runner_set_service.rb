require_relative 'http_json/request_packer'
require_relative 'http_json/response_unpacker'
require_relative 'runner_set_exception'

class RunnerSetService

  def initialize(externals)
    requester = HttpJson::RequestPacker.new(externals.http, 'runner-set-server', 4599)
    @http = HttpJson::ResponseUnpacker.new(requester, RunnerSetException)
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

  def heartbeat(ip_address)
    @http.post(__method__, {
      ip_address:ip_address
    })
  end

  def pull_images(id, event, image_names)
    @http.post(__method__, {
      id:id,
      event:event,
      image_names:image_names
    })
  end

  def run_cyber_dojo_sh(id, files, manifest)
    @http.post(__method__, {
      id:id,
      files:files,
      manifest:manifest
    })
  end

end
