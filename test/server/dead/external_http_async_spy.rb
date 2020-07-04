# frozen_string_literal: true

class ExternalHttpAsyncSpy

  def initialize
    clear
  end

  def post(hostname, port, path, body)
    @spied << {
      hostname:hostname,
      port:port,
      path:path,
      body:body
    }
  end

  def clear
    @spied = []
  end

  attr_reader :spied

end
