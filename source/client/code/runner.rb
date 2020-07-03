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
    Process.detach(fork {
      Process.setsid
      # TODO: write infoto /tmp/ file so test can retrieve it
      puts("pid:#{Process.pid}, id:#{id}, image_name:#{image_name}")
      #puts `ps -aux`
      sleep 1
    })
    { 'pull_image' => 'TODO' } # return ip-address?
  end

  private

  def puller
    @externals.puller
  end

end
