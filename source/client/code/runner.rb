# frozen_string_literal: true

class Runner

  def initialize(externals)
    @externals = externals
  end

  def sha
    ENV['SHA']
  end

  def alive?
    true
  end

  def ready?
    puller.ready?
  end

  # - - - - - - - - - - - - - - - -

  def pull_images(id:, image_name:)
    # TODO: write to /tmp/ file so test can retrieve it
  end

  private

  def puller
    @externals.puller
  end

end
