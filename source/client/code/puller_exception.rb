require_relative 'http_json/service_exception'

class PullerException < HttpJson::ServiceException

  def initialize(message)
    super
  end

end
