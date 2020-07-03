require_relative 'http_json/service_exception'

class RunnerSetException < HttpJson::ServiceException

  def initialize(message)
    super
  end

end
