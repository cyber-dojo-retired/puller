# frozen_string_literal: true
require_relative 'runner_http_proxy'

class Puller

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
    { 'ready?' => true }
  end

  # - - - - - - - - - - - - - - - -

  def pull_images(id:, image_name:)
    16.times do |i|
      runner('runner').pull_image(id+"-#{i}", image_name)
    end
    { 'pull_images' => 'TODO' }
  end

  # - - - - - - - - - - - - - - - -

  private

  def runner(hostname)
    RunnerHttpProxy.new(@externals, hostname)
  end

end
