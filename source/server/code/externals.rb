# frozen_string_literal: true
require_relative 'external_http_async'

class Externals

  def initialize(options = {})
    @http_async = options[:http_async] || ExternalHttpAsync.new(self)
  end

  attr_reader :http_async

end
