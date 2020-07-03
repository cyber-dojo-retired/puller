# frozen_string_literal: true

class ExternalTimeStub

  def stub(now)
    @stub = now
  end

  def now
    @stub
  end

end
