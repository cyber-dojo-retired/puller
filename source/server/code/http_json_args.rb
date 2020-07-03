# frozen_string_literal: true
require 'json'

class HttpJsonArgs

  class RequestError < RuntimeError
    def initialize(message)
      # message uses the words 'body' and 'path'
      # to match RackDispatcher's exception keys.
      super
    end
  end

  # - - - - - - - - - - - - - - - -

  def self.dispatch(path, puller, body)
    args = parse_json_args(body)
    case path
    when '/sha'               then puller.sha(**args)
    when '/alive'             then puller.alive?(**args)
    when '/ready'             then puller.ready?(**args)
    when '/async_pull_images' then puller.async_pull_images(**args)
    when '/async_pull_image'  then puller.async_pull_image(**args)
    else raise RequestError, 'unknown path'
    end
  rescue JSON::JSONError
    raise RequestError, 'body is not JSON'
  rescue ArgumentError => caught
    if r = caught.message.match('(missing|unknown) keyword(s?): (.*)')
      raise RequestError, "#{r[1]} argument#{r[2]}: #{r[3]}"
    end
    raise
  end

  private

  def self.parse_json_args(body)
    args = {}
    unless body === ''
      json = JSON.parse!(body)
      unless json.is_a?(Hash)
        raise RequestError, 'body is not JSON Hash'
      end
      # double-splat requires symbol keys
      json.each { |key,value| args[key.to_sym] = value }
    end
    args
  end

end
