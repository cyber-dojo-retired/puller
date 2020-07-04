# frozen_string_literal: true
require 'ostruct'

class ExternalHttpSyncSpy

  def initialize(name)
    @name = name
    clear
  end

  def post(uri)
    @uri = uri
    OpenStruct.new(content_type:'', body:'')
  end

  def start(_hostname, _port, request)
    @spied << {
      uri:@uri,
      request:request
    }
    body = { @name => {} }.to_json
    OpenStruct.new(body:body) # for response unpacker
  end

  def clear
    @spied = []
  end

  attr_reader :spied

end
