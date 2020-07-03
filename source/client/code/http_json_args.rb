# frozen_string_literal: true

require_relative 'http_json/request_error'

class HttpJsonArgs

  def get(path)
    case path
    when '/ready'       then ['ready?',[]]
    when '/pull_images' then ['pull_images', args]
    else
      raise HttpJson::RequestError, 'unknown path'
    end
  end

  # - - - - - - - - - - - - - - - - - -


end
