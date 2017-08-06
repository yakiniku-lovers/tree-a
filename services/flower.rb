# frozen_string_literal: true

require 'open3'

class Flower
  SCRIPT_PATH = './submodules/tree-d/flower_generator.py'

  def initialize(saved_path)
    @path = saved_path
  end

  def generate(options = {})
    arg = "-o #{@path} "
    arg += "-c #{options[:colors].join(' ')} " if options[:colors]
    arg += "-n #{options[:number]} " if options[:number]
    arg += "-t #{options[:type]}" if options[:type]

    o, = Open3.capture3("python #{SCRIPT_PATH} #{arg}")

    o
  end
end
