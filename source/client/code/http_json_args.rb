# frozen_string_literal: true
require_relative 'http_json/request_error'
require 'json'

class HttpJsonArgs

  def get(path, runner, body)
    args = parse_json_args(body)
    case path
    when '/sha'         then runner.sha(**args)
    when '/alive'       then runner.alive?(**args)
    when '/ready'       then runner.ready?(**args)
    when '/pull_images' then runner.pull_images(**args)
    when '/pull_image'  then runner.pull_image(**args)
    else
      raise HttpJson::RequestError, 'unknown path'
    end
  end

  private

  def parse_json_args(body)
    args = {}
    unless body === ''
      json = JSON.parse!(body)
      unless json.is_a?(Hash)
        raise HttpJson::RequestError, 'body is not JSON Hash'
      end
      # double-splat requires symbol keys
      json.each { |key,value| args[key.to_sym] = value }
    end
    args
  end

end
