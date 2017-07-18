require 'open3'

class Flower
  SCRIPT_PATH = './submodules/tree-d/flower_generater.py'.freeze

  def initialize(saved_path)
    @path = saved_path
  end

  def generate(options = {})
    arg = "-o #{@path} "
    arg << "-c #{options[:colors][0]} #{options[:colors][1]} #{options[:colors][2]} " if options[:colors]
    arg << "-n #{options[:number]} " if options[:number]
    arg << "-t #{options[:type]}" if options[:type]

    o, = Open3.capture3("python #{SCRIPT_PATH} #{arg}")

    o
  end
end
