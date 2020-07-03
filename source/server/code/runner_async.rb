# frozen_string_literal: true

class RunnerAsync

  def initialize(externals, hostname)
    @externals = externals
    @hostname = hostname
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def pull_image(id, image_name)
    @externals.http_async.post(@hostname, RUNNER_PORT, __method__.to_s, {
      id:id,
      image_name:image_name
    })
  end

  private

  RUNNER_PORT = 4597

end
