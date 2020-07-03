# frozen_string_literal: true
require_relative 'runner_async'

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

  def async_pull_images(id:, image_name:)
    16.times do |i|
      runner_async('runner').pull_image(id+"-#{i}", image_name)
    end
    { 'async_pull_images' => nil }
  end

  # - - - - - - - - - - - - - - - -

  def async_pull_image(id:, image_name:, ip_address:)
    runner_async(ip_address).pull_image(id, image_name)
    { 'async_pull_image' => nil }
  end

  # - - - - - - - - - - - - - - - -

  private

  def runner_async(hostname)
    RunnerAsync.new(@externals, hostname)
  end

end
