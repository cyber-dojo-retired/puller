# frozen_string_literal: true

class ExternalSamplerStub

  def initialize
    @value = nil
  end

  def stub(value)
    @value = value
  end

  def sample(_from)
    @value
  end

end
