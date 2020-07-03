# frozen_string_literal: true
require_relative 'http_json/request_error'

class HttpJsonArgs

  def get(path)
    case path
    when '/sha'        then ['sha',[]]
    when '/alive'      then ['alive?',[]]
    when '/ready'      then ['ready?',[]]
    when '/pull_image' then ['pull_image', args]
    else
      raise HttpJson::RequestError, 'unknown path'
    end
  end

  # - - - - - - - - - - - - - - - - - -


end
