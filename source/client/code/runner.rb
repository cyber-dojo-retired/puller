# frozen_string_literal: true

class Runner

  def initialize(_externals)
    #@externals = externals
  end

  def sha
    { 'sha' => ENV['SHA'] }
  end

  def alive?
    { 'alive?' => true }
  end

  def ready?
    { 'ready?' => true }
  end

  # - - - - - - - - - - - - - - - -

  def pull_image(id:, image_name:)
    Thread.new { threaded_pull_image(id, image_name) }
    { 'pull_image' => 'TODO' }
    # { 'pull_image' => { ip-address => node.image_names } }
  end

  private

  def threaded_pull_image(id, image_name)
    # TODO: write infoto /tmp/ file so test can retrieve it
    tid = Thread.current.object_id
    puts("pid:#{Process.pid}, tid:#{tid} id:#{id}, image_name:#{image_name}")
    #puts `ps -aux`
    sleep 10
    Thread::current.exit
  end

end
