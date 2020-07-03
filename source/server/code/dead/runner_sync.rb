# frozen_string_literal: true
require_relative 'http_json_hash/service'

class RunnerSync

  def initialize(externals, ip_address)
    @externals = externals
    @ip_address = ip_address
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def pull_image(id, image_name)
    http_sync(ip_address_.post(__method__, {
      id:id,
      image_name:image_name
    })
  end

  private

  def http_sync(ip_address)
    hostname = ip_address
    name = "runner_sync@(#{hostname})"
    HttpJsonHash::service(name, @externals.http_sync, ip_address, RUNNER_PORT)
  end

  RUNNER_PORT = 4597

end
