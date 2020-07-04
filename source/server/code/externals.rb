# frozen_string_literal: true
require_relative 'external_http_sync'

class Externals

  def initialize(options = {})
    @http = options[:http] || ExternalHttpSync.new(self)
  end

  attr_reader :http

end
