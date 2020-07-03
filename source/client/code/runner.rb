# frozen_string_literal: true

class Runner

  def initialize(externals)
    @externals = externals
  end

  def sha
    { 'sha' => ENV['SHA'] }
  end

  def alive?
    { 'alive?' => true }
  end

  def ready?
    { 'ready?' => puller.ready? }
  end

  # - - - - - - - - - - - - - - - -

  def pull_image(id:, image_name:)
    # TODO: write to /tmp/ file so test can retrieve it
    puts("tid:#{Thread.current.object_id}, id:#{id}, image_name:#{image_name}")
    #sleep 1
    { 'pull_image' => 'TODO' }
  end

  private

  def puller
    @externals.puller
  end

end
