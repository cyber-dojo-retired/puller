# frozen_string_literal: true
require 'net/http'

class Externals

  def initialize(options = {})
    @http = options[:http] || Net::HTTP
  end

  attr_reader :http

end
