require 'pathname'

class Traverser
  IGNORE_PATTERNS = [
    /\.DS_Store$/,
    /\._/
  ]

  attr_reader :current

  def initialize path, file_system
    @file_system = file_system
    @path = Pathname.new path
    @path.mkpath
    @traverser = Fiber.new do
      @path.find { |child| Fiber.yield child if child.file? }
      Fiber.yield nil
    end
    @current = @traverser.resume
  end

  def description
    empty? ? 'empty' : "#{name}:#{ts}"
  end

  def base
    @path
  end

  def advance
    @current = @traverser.resume if @current
  end
  alias next advance

  def name
    @current.relative_path_from(@path).to_s if @current
  end

  def ts
    @current.mtime.to_i if @current
  end

  def to_s
    "#{relative}:#{timestamp}"
  end

  def empty?
    @current.nil?
  end

  def ignored?
    IGNORE_PATTERNS.any? {|pattern| pattern.match name }
  end

  def cp *traversers
    traversers.each do |t|
      @file_system.cp @current.to_s, "#{t.base}/#{name}" unless description == t.description
    end
  end
end